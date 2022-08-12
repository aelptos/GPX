//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func insert(_ host: UIViewController, parent: UIViewController? = nil) {
        if let parent = parent {
            parent.addChild(host)
        }

        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        host.view.backgroundColor = .clear

        if let parent = parent {
            host.didMove(toParent: parent)
        }
    }
}
