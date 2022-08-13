//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UIApplication {
    var darkModeAppIconName: String { "AppIcon-Dark" }

    func setAlternateAppIconIfNeeded(_ controller: UIViewController) {
        guard supportsAlternateIcons else { return }
        let style = controller.traitCollection.userInterfaceStyle
        let iconName = alternateIconName ?? ""
        var shouldSetIcon = false
        var newIconName: String?
        if style == .dark && iconName != darkModeAppIconName {
            shouldSetIcon = true
            newIconName = darkModeAppIconName
        } else if style == .light && iconName == darkModeAppIconName {
            shouldSetIcon = true
        }
        guard shouldSetIcon else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setAlternateIconName(newIconName) { error in
                print(String(describing: error))
            }
        }
    }
}
