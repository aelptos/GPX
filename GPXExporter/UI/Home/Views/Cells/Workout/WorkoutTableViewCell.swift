//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import SwiftUI

final class WorkoutTableViewCell: UITableViewCell, ReusableCell {
    static var cellReuseIdentifer = "WorkoutTableViewCell"

    func configure(with viewModel: WorkoutViewModel, parent: UIViewController) {
        insert(
            UIHostingController(rootView: WorkoutCellView(viewModel: viewModel)),
            parent: parent
        )
        accessoryType = .disclosureIndicator
    }
}
