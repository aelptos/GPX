//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

class CellFactory {
    private weak var tableView: UITableView?

    func registerCells(forUseIn tableView: UITableView) {
        self.tableView = tableView
    }

    var registeredTableView: UITableView {
        guard let tableView = tableView else {
            preconditionFailure("`tableview` is not set on cell factory")
        }
        return tableView
    }
}
