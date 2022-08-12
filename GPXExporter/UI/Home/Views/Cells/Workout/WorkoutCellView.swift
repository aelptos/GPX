//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import HealthKit

struct WorkoutCellView: View {
    let viewModel: WorkoutViewModel

    var body: some View {
        HStack {
            Text("\(viewModel.date) - \(viewModel.activity)")
            Spacer()
        }
        .padding()
    }
}

struct WorkoutCellView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCellView(viewModel: WorkoutViewModel(
            activity: "Walking",
            date: "2022-08-12",
            workout: HKWorkout(
                activityType: .walking,
                start: Date(),
                end: Date()
            )
        ))
            .previewLayout(.sizeThatFits)
    }
}
