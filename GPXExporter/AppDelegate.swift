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
        window?.rootViewController = composeRoot()
        window?.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {
    func composeRoot() -> UIViewController {
        let healthKitHelper = HealthKitHelper()
        let homeController = HomeViewController(healthKitHelper: healthKitHelper)
        let navigationController = UINavigationController(rootViewController: homeController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
