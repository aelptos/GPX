//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import HealthKit

struct WorkoutCellView: View {
    let workout: HKWorkout

    var body: some View {
        HStack {
            Image(systemName: workout.activityIconName)
                .font(.title)
            VStack(alignment: .leading) {
                Text(workout.humanReadableDuration)
                Text(workout.humanReadableDistance)
                    .font(.caption)
            }
            Spacer()
            Text(workout.displayDate)
                .font(.footnote)
        }
        .padding()
    }
}

struct WorkoutCellView_Previews: PreviewProvider {
    static var sampleWorkout: HKWorkout = {
        HKWorkout(
            activityType: .cycling,
            start: Date(),
            end: Date()
        )
    }()

    static var previews: some View {
        Group {
            WorkoutCellView(workout: sampleWorkout)
                .preferredColorScheme(.light)
            WorkoutCellView(workout: sampleWorkout)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
