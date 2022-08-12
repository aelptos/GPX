//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

struct Formatters {
    static let dateDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()

    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter
    }()

    static let distanceFormatter: LengthFormatter = {
        LengthFormatter()
    }()
}
