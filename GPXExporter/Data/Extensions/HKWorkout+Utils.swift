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
        case .hiking:
            return "figure.hiking"
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .cycling:
            return "bicycle"
        case .swimming:
            return "figure.pool.swim"
        default:
            return "questionmark"
        }
    }

    var activityNamePast: String {
        switch workoutActivityType {
        case .hiking:
            return "activity.hiked".localized
        case .running:
            return "activity.ran".localized
        case .walking:
            return "activity.walked".localized
        case .cycling:
            return "activity.cycled".localized
        case .swimming:
            return "activity.swam".localized
        default:
            return "activity.moved".localized
        }
    }
}
