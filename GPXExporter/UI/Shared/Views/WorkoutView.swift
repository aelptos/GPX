//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    let workout: HKWorkout

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workout.activityIconName)
                .font(.title)
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text("\(workout.activityNamePast) for \(workout.humanReadableDuration)")
                    Spacer()
                    Text(workout.humanReadableDistance)
                        .font(.caption)
                }
                HStack(spacing: 2) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("Date:")
                            .font(.caption2)
                        Text(workout.displayDate)
                    }
                    Spacer()
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("Start:")
                            .font(.caption2)
                        Text(workout.displayStartTime)
                    }
                    Spacer()
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("End:")
                            .font(.caption2)
                        Text(workout.displayEndTime)
                    }
                }
                .font(.footnote)
            }
        }
        .padding()
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var sampleWorkout: HKWorkout = {
        HKWorkout(
            activityType: .cycling,
            start: Date(),
            end: Date()
        )
    }()

    static var previews: some View {
        Group {
            WorkoutView(workout: sampleWorkout)
                .preferredColorScheme(.light)
            WorkoutView(workout: sampleWorkout)
                .preferredColorScheme(.dark)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
