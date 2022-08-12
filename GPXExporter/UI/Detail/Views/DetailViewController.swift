//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import HealthKit

final class DetailViewController: UITableViewController {
    private let healthKitHelper: HealthKitHelperProtocol
    private let workout: HKWorkout

    init(
        healthKitHelper: HealthKitHelperProtocol,
        workout: HKWorkout
    ) {
        self.healthKitHelper = healthKitHelper
        self.workout = workout
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
}

private extension DetailViewController {
    func setupNavigation() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Export",
            style: .plain,
            target: self,
            action: #selector(onExportButtonTap)
        )
    }

    @objc func onExportButtonTap() {}
}
