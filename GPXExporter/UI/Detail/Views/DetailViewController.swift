//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

final class DetailViewController: UITableViewController {
    private let healthKitHelper: HealthKitHelperProtocol
    private let listViewModel: WorkoutViewModel

    init(
        healthKitHelper: HealthKitHelperProtocol,
        listViewModel: WorkoutViewModel
    ) {
        self.healthKitHelper = healthKitHelper
        self.listViewModel = listViewModel
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
