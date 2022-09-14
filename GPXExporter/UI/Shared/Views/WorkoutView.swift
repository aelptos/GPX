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
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color(UIColor.tertiarySystemBackground))
                        .frame(width: 40, height: 40)
                )
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text("\(workout.activityNamePast) \("workout.for".localized) \(workout.humanReadableDuration)")
                    Spacer()
                    Text(workout.humanReadableDistance)
                        .font(.caption)
                }
                HStack(spacing: 2) {
                    Text(workout.displayDate)
                    Spacer()
                    HStack(alignment: .center, spacing: 8) {
                        Text(workout.displayStartTime)
                        Image(systemName: "arrow.forward")
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
