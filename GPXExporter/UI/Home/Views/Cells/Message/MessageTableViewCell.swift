//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import SwiftUI

final class MessageTableViewCell: UITableViewCell, ReusableCell {
    static var cellReuseIdentifer = "MessageTableViewCell"

    func configure(with message: String, parent: UIViewController) {
        insert(
            UIHostingController(rootView: MessageCellView(message: message)),
            parent: parent
        )
        selectedBackgroundView = UIView()
    }
}
