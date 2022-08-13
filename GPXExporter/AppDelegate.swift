//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = composeRoot()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        application.setAlternateAppIconIfNeeded(rootViewController)
        return true
    }
}

private extension AppDelegate {
    func composeRoot() -> UIViewController {
        let healthKitHelper = HealthKitHelper()
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        let router = Router(
            navigationController: navigationController
        )
        let presenter = HomePresenter(
            router: router,
            healthKitHelper: healthKitHelper
        )
        let controller = HomeViewController(
            presenter: presenter,
            cellFactory: HomeViewCellFactory()
        )
        presenter.view = controller
        navigationController.viewControllers = [controller]
        return navigationController
    }
}
