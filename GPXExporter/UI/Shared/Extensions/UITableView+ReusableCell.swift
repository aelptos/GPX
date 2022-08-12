//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ReusableCell {
        dequeueReusableCell(withIdentifier: T.cellReuseIdentifer) as! T
    }

    func registerReusableCell<T: UITableViewCell>(_ cellType: T.Type) where T: ReusableCell {
        register(cellType, forCellReuseIdentifier: cellType.cellReuseIdentifer)
    }
}
