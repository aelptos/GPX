//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import HealthKit

protocol RouterProtocol {
    func showDetail(for workout: HKWorkout)
    func showProgress()
    func hideProgress()
}

final class Router {
    private let navigationController: UINavigationController
    private var isShowingProgres = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension Router: RouterProtocol {
    @discardableResult
    func synchronized<T>(_ lock: AnyObject, closure: () -> T) -> T {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }

        return closure()
    }

    func showDetail(for workout: HKWorkout) {}

    func showProgress() {
        synchronized(self) {
            guard !self.isShowingProgres else { return }
            self.isShowingProgres = true
            DispatchQueue.main.async {
                let loadingVC = LoadingViewController()
                loadingVC.modalPresentationStyle = .overCurrentContext
                loadingVC.modalTransitionStyle = .crossDissolve
                self.navigationController.present(loadingVC, animated: true, completion: nil)
            }
        }
    }

    func hideProgress() {
        synchronized(self) {
            guard self.isShowingProgres else { return }
            DispatchQueue.main.async {
                self.navigationController.dismiss(animated: true) {
                    self.isShowingProgres = false
                }
            }
        }
    }
}
