//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

struct WorkoutViewModelBuilder {
    static func build(with workouts: [HKWorkout]) -> [WorkoutViewModel] {
        workouts.map { workout in
            WorkoutViewModel(
                activity: activityName(for: workout),
                date: dateFormatter.string(from: workout.startDate),
                workout: workout
            )
        }
    }
}

private extension WorkoutViewModelBuilder {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter
    }()

    static func activityName(for workout: HKWorkout) -> String {
        switch workout.workoutActivityType {
        case .walking:
            return "Walking"
        case .running:
            return "Running"
        case .hiking:
            return "Hiking"
        case .cycling:
            return "Cycling"
        default:
            return "Other"
        }
    }
}
