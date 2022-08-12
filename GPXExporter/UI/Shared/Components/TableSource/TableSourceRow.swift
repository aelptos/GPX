//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

final class TableSourceRow {
    private let configurationBlock: () -> UITableViewCell
    private let onTapHandler: ((IndexPath) -> Void)?

    let isSelectable: Bool

    init(
        configurationBlock: @escaping () -> UITableViewCell,
        onTapHandler: ((IndexPath) -> Void)?,
        isSelectable: Bool = true
    ) {
        self.configurationBlock = configurationBlock
        self.onTapHandler = onTapHandler
        self.isSelectable = isSelectable
    }

    func makeCell() -> UITableViewCell {
        configurationBlock()
    }

    func triggerAction(_ indexPath: IndexPath) {
        guard isSelectable, let onTapHandler = onTapHandler else { return }
        onTapHandler(indexPath)
    }
}
