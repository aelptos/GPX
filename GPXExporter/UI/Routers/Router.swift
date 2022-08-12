//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func showDetail(for workout: WorkoutViewModel)
}

final class Router {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension Router: RouterProtocol {
    func showDetail(for workout: WorkoutViewModel) {}
}
