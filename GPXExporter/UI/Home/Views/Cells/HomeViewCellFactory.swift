//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import HealthKit

final class HomeViewCellFactory: CellFactory {
    override func registerCells(forUseIn tableView: UITableView) {
        super.registerCells(forUseIn: tableView)
        tableView.registerReusableCell(LoadingTableViewCell.self)
        tableView.registerReusableCell(MessageTableViewCell.self)
        tableView.registerReusableCell(WorkoutTableViewCell.self)
    }

    func makeLoadingCell(parent: UIViewController) -> LoadingTableViewCell {
        let cell: LoadingTableViewCell = registeredTableView.dequeueReusableCell()
        cell.configure(parent: parent)
        return cell
    }

    func makeMessageCell(with message: String, parent: UIViewController) -> MessageTableViewCell {
        let cell: MessageTableViewCell = registeredTableView.dequeueReusableCell()
        cell.configure(with: message, parent: parent)
        return cell
    }

    func makeWorkoutCell(with workout: HKWorkout, parent: UIViewController) -> WorkoutTableViewCell {
        let cell: WorkoutTableViewCell = registeredTableView.dequeueReusableCell()
        cell.configure(with: workout, parent: parent)
        return cell
    }
}
