//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(formatting value: Int) {
        guard let result = Formatters.numberFormatter.string(from: value as NSNumber) else { return }
        appendLiteral(result)
    }
}
