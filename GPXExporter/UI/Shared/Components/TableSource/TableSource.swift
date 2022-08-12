//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

final class TableSource {
    private var sections = [TableSourceSection]()

    var sectionsCount: Int {
        sections.count
    }

    func prepareForReuse() {
        sections.removeAll()
    }

    func add(_ section: TableSourceSection) {
        sections.append(section)
    }

    func section(for index: Int) -> TableSourceSection {
        guard index < sections.count else {
            preconditionFailure("Index \(index) out of bounds")
        }
        return sections[index]
    }

    func row(for indexPath: IndexPath) -> TableSourceRow {
        section(for: indexPath.section)
            .row(for: indexPath.row)
    }
}
