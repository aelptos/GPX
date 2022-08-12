//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import SwiftUI
import HealthKit

final class WorkoutTableViewCell: UITableViewCell, ReusableCell {
    static var cellReuseIdentifer = "WorkoutTableViewCell"

    func configure(with workout: HKWorkout, parent: UIViewController) {
        insert(
            UIHostingController(rootView: WorkoutCellView(workout: workout)),
            parent: parent
        )
        accessoryType = .disclosureIndicator
    }
}
