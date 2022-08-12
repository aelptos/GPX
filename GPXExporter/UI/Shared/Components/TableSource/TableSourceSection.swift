//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

final class TableSourceSection {
    private var rows = [TableSourceRow]()

    var headerText: String?
    var footerText: String?

    var rowsCount: Int {
        rows.count
    }

    func add(_ row: TableSourceRow) {
        rows.append(row)
    }

    func row(for index: Int) -> TableSourceRow {
        guard index < rows.count else {
            preconditionFailure("Index \(index) out of bounds")
        }
        return rows[index]
    }
}
