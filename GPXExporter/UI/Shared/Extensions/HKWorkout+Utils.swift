//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

extension HKWorkout {
    var displayDate: String {
        Formatters.dateDisplayFormatter.string(from: endDate)
    }

    var displayStartTime: String {
        Formatters.timeDisplayFormatter.string(from: startDate)
    }

    var displayEndTime: String {
        Formatters.timeDisplayFormatter.string(from: endDate)
    }

    var humanReadableDuration: String {
        Formatters.durationFormatter.string(from: duration) ?? "-"
    }

    var humanReadableDistance: String {
        guard var distance = totalDistance?.doubleValue(for: .meter()) else { return "-" }
        distance = distance / 1000
        return Formatters.distanceFormatter.string(fromValue: distance.round(to: 2), unit: .kilometer)
    }

    var activityIconName: String {
        switch workoutActivityType {
        case .hiking, .running, .walking:
            return "figure.walk.circle.fill"
        case .cycling:
            return "bicycle.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    var activityNamePast: String {
        switch workoutActivityType {
        case .hiking:
            return "Hiked"
        case .running:
            return "Ran"
        case .walking:
            return "Walked"
        case .cycling:
            return "Cycled"
        case .swimming:
            return "Swam"
        default:
            return "Moved"
        }
    }
}
