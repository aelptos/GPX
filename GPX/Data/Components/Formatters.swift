//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

struct Formatters {
    static let dateDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    static let timeDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    static let distanceFormatter: LengthFormatter = {
        LengthFormatter()
    }()

    static let numberFormatter: NumberFormatter = {
        NumberFormatter()
    }()
}
