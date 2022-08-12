//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func update(_ viewModel: HomeViewModel)
}

final class HomeViewController: UITableViewController {
    private let presenter: HomePresenterProtocol

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }

    private var workouts = [WorkoutViewModel]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = "\(workout.date) - \(workout.activity)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(workouts[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: HomeViewProtocol {
    func update(_ viewModel: HomeViewModel) {
        switch viewModel {
        case .initial, .unauthorized, .unavailable, .failedFetch:
            workouts = []
        case let .results(workouts):
            self.workouts = workouts
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

private extension HomeViewController {
    func setupNavigation() {
        title = "GPXExporter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Fetch",
            style: .plain,
            target: self,
            action: #selector(onFetchButtonTap)
        )
    }

    @objc func onFetchButtonTap() {
        presenter.didRequestFetch()
    }
}
