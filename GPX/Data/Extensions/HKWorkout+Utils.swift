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
        case .cycling:
            return "bicycle"
        case .hiking:
            return "figure.hiking"
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        default:
            return "questionmark"
        }
    }

    var activityNamePast: String {
        switch workoutActivityType {
        case .cycling:
            return "activity.cycled".localized
        case .hiking:
            return "activity.hiked".localized
        case .running:
            return "activity.ran".localized
        case .walking:
            return "activity.walked".localized
        default:
            return "activity.moved".localized
        }
    }
}

#if DEBUG
    extension HKWorkout {
        static func samples() -> [HKWorkout] {
            [
                HKWorkout.sample(for: .cycling),
                HKWorkout.sample(for: .hiking),
                HKWorkout.sample(for: .running),
                HKWorkout.sample(for: .walking)
            ]
        }

        static func sample(for activity: HKWorkoutActivityType) -> HKWorkout {
            HKWorkout(
                activityType: activity,
                start: Date().addingTimeInterval(-3900),
                end: Date(),
                workoutEvents: nil,
                totalEnergyBurned: nil,
                totalDistance: HKQuantity(unit: .meter(), doubleValue: 5100),
                metadata: nil
            )
        }
    }
#endif
