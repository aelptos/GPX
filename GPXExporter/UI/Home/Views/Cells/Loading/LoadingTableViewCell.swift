//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import SwiftUI

final class LoadingTableViewCell: UITableViewCell, ReusableCell {
    static var cellReuseIdentifer = "LoadingTableViewCell"

    func configure(parent: UIViewController) {
        insert(
            UIHostingController(rootView: LoadingCellView()),
            parent: parent
        )
        selectedBackgroundView = UIView()
    }
}
