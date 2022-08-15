//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import HealthKit

protocol HomeViewProtocol: AnyObject {
    func prepareView()
    func update(_ viewModel: HomeViewModel)
}

final class HomeViewController: UITableViewController {
    private let presenter: HomePresenterProtocol
    private let cellFactory: HomeViewCellFactory

    private var tableSource = TableSource()
    private var sectionIndexes = [String]()

    init(
        presenter: HomePresenterProtocol,
        cellFactory: HomeViewCellFactory
    ) {
        self.presenter = presenter
        self.cellFactory = cellFactory
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidAppear()
    }

    // MARK: - UITableView data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableSource.sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSource.section(for: section).rowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableSource.row(for: indexPath).makeCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableSource.section(for: section).headerText
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexes.map { String($0.suffix(2)) }
    }

    // MARK: - UITableView delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableSource.row(for: indexPath).isSelectable ? indexPath : nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = tableSource.row(for: indexPath)
        guard row.isSelectable else { return }
        row.triggerAction(indexPath)
    }
}

extension HomeViewController: HomeViewProtocol {
    func prepareView() {
        setupNavigation()
        setupPullDownToRefresh()
        cellFactory.registerCells(forUseIn: tableView)
    }

    func update(_ viewModel: HomeViewModel) {
        var enableUserInteraction = true
        tableSource.prepareForReuse()
        sectionIndexes.removeAll()
        switch viewModel {
        case .initial:
            enableUserInteraction = false
            updateTableSourceForLoading()
        case .unauthorized:
            updateTableSource(with: "home.health.access.unauthorized.error".localized)
        case .unavailable:
            updateTableSource(with: "home.health.access.unavailable.error".localized)
        case .failedFetch:
            updateTableSource(with: "home.workouts.fetch.error".localized)
        case let .results(workoutsPerYear):
            sectionIndexes = workoutsPerYear.keys.sorted(by: { $0 > $1 })
            updateTableSource(with: workoutsPerYear)
        }
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = enableUserInteraction
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

private extension HomeViewController {
    func setupNavigation() {
        title = "app.name".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(onInfoButtonTap)
        )
    }

    @objc func onInfoButtonTap() {
        presenter.didRequestInfo()
    }

    func setupPullDownToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func onRefresh() {
        view.isUserInteractionEnabled = false
        presenter.didRequestFetch()
    }

    func updateTableSourceForLoading() {
        let section = TableSourceSection()
        section.add(
            TableSourceRow(
                configurationBlock: { [weak self] in
                    guard let self = self else { return UITableViewCell() }
                    return self.cellFactory.makeLoadingCell(parent: self)
                },
                onTapHandler: nil,
                isSelectable: false
            )
        )
        tableSource.add(section)
    }

    func updateTableSource(with message: String) {
        let section = TableSourceSection()
        section.add(
            TableSourceRow(
                configurationBlock: { [weak self] in
                    guard let self = self else { return UITableViewCell() }
                    return self.cellFactory.makeMessageCell(
                        with: message,
                        parent: self
                    )
                },
                onTapHandler: nil,
                isSelectable: false
            )
        )
        tableSource.add(section)
    }

    func updateTableSource(with workoutsPerYear: [String: [HKWorkout]]) {
        for year in workoutsPerYear.keys.sorted(by: { $0 > $1 }) {
            let section = TableSourceSection()
            section.headerText = year
            for workout in workoutsPerYear[year]! {
                section.add(
                    TableSourceRow(
                        configurationBlock: { [weak self] in
                            guard let self = self else { return UITableViewCell() }
                            return self.cellFactory.makeWorkoutCell(
                                with: workout,
                                parent: self
                            )
                        },
                        onTapHandler: { [weak self] _ in
                            guard let self = self else { return }
                            self.presenter.didSelect(workout)
                        }
                    )
                )
            }
            tableSource.add(section)
        }

        if workoutsPerYear.isEmpty {
            let section = TableSourceSection()
            section.add(
                TableSourceRow(
                    configurationBlock: { [weak self] in
                        guard let self = self else { return UITableViewCell() }
                        return self.cellFactory.makeMessageCell(
                            with: "home.workouts.empty".localized,
                            parent: self
                        )
                    },
                    onTapHandler: nil,
                    isSelectable: false
                )
            )
            tableSource.add(section)
        }
    }
}
