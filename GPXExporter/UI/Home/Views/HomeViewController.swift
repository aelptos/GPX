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
        switch viewModel {
        case .initial:
            enableUserInteraction = false
            updateTableSourceForLoading()
        case .unauthorized:
            updateTableSource(with: "Access to workouts is unauthorized\nPlease check your settings")
        case .unavailable:
            updateTableSource(with: "Health is not available at this time\nPlease check again later")
        case .failedFetch:
            updateTableSource(with: "Failed to fetch workouts from Health\nPlease check again later")
        case let .results(workouts):
            updateTableSource(with: workouts)
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
        title = "GPXExporter"
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

    func updateTableSource(with workouts: [HKWorkout]) {
        let section = TableSourceSection()
        for workout in workouts {
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
        if workouts.isEmpty {
            section.add(
                TableSourceRow(
                    configurationBlock: { [weak self] in
                        guard let self = self else { return UITableViewCell() }
                        return self.cellFactory.makeMessageCell(
                            with: "No workout found in Health\nGo for a walk or something",
                            parent: self
                        )
                    },
                    onTapHandler: nil,
                    isSelectable: false
                )
            )
        }
        tableSource.add(section)
    }
}
