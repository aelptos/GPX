//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    static func show(with url: URL) {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else { return }
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.sourceView = rootController.view
            controller.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height,
                width: 0,
                height: 0
            )
            controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        }
        rootController.present(controller, animated: true, completion: nil)
    }
}
