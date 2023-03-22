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
                .padding([.leading, .trailing], 4)
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

#if DEBUG
    struct WorkoutView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutView(workout: HKWorkout.sample(for: .cycling))
        }
    }
#endif
