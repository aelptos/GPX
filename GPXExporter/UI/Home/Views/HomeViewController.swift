//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

final class HomeViewController: UITableViewController {
    private let healthKitHelper: HealthKitHelperProtocol

    init(healthKitHelper: HealthKitHelperProtocol) {
        self.healthKitHelper = healthKitHelper
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
        guard healthKitHelper.isHealthDataAvailable() else {
            showError(with: "Health data is not available")
            return
        }

        healthKitHelper.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    self.showError(with: "Authorization failed with \(error)")
                case let .success(status):
                    guard status else {
                        self.showError(with: "Authorization failed")
                        return
                    }
                    self.fetchWorkouts()
                }
            }
        }
    }

    func showError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }

    func fetchWorkouts() {
        healthKitHelper.fetchWorkouts { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    self.showError(with: "Authorization failed with \(error)")
                case let .success(workouts):
                    self.workouts = workouts
                    self.tableView.reloadData()
                }
            }
        }
    }
}
