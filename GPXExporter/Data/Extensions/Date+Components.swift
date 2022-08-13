//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.dateComponents([.year], from: self).year ?? 0
    }
}
