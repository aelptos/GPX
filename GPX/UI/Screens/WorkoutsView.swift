//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import HealthKit

struct WorkoutsView: View {
    private enum ScreenState {
        case initial
        case unauthorized
        case unavailable
        case failedFetch
        case results([HKWorkout])
    }

    @State private var state: ScreenState = .initial
    @State private var loading = false
    @State private var initiaLoadHasBeenDone = false

    private let healthKitHelper: HealthKitHelperProtocol

    init(
        healthKitHelper: HealthKitHelperProtocol
    ) {
        self.healthKitHelper = healthKitHelper
    }

    var body: some View {
        List {
            switch state {
            case .initial:
                loadingSection
            case .unauthorized:
                unauthorizedSection
            case .unavailable:
                unavailableSection
            case .failedFetch:
                failedFetchSection
            case let .results(workouts):
                if workouts.isEmpty {
                    emptyWorkoutsSection
                } else {
                    workoutsSections(with: workouts)
                    workoutsCountSection(for: workouts)
                }
            }
        }
        .task {
            await initialFetch()
        }
        .refreshable {
            await requestFetch()
        }
        .navigationTitle("workouts.title".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension WorkoutsView {
    var loadingSection: some View {
        Section {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .listRowBackground(Color.clear)
            .padding()
        }
    }

    var unauthorizedSection: some View {
        messageSection(
            "health.access.unauthorized.error".localized,
            icon: "lock.trianglebadge.exclamationmark.fill"
        )
    }

    var unavailableSection: some View {
        messageSection(
            "health.access.unavailable.error".localized,
            icon: "exclamationmark.triangle"
        )
    }

    var failedFetchSection: some View {
        messageSection(
            "workouts.fetch.error".localized,
            icon: "exclamationmark.circle"
        )
    }

    var emptyWorkoutsSection: some View {
        messageSection(
            "workouts.empty".localized,
            icon: "figure.walk.motion"
        )
    }

    func messageSection(
        _ message: String,
        icon: String? = nil
    ) -> some View {
        Section {
            HStack {
                Spacer()
                MessageView(text: message, icon: icon)
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
    }

    func workoutsSections(with workouts: [HKWorkout]) -> some View {
        let splittedWorkouts = splitWorkoutsByYear(workouts)
        let years = splittedWorkouts.keys.sorted(by: { $0 > $1 })
        return ForEach(years, id: \.self) { year in
            Section {
                ForEach(splittedWorkouts[year]!, id: \.self) { workout in
                    NavigationLink {
                        WorkoutDetailsView(
                            healkitHelper: healthKitHelper,
                            workout: workout
                        )
                        .toolbar(.hidden, for: .tabBar)
                    } label: {
                        WorkoutView(workout: workout)
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 16
                        )
                    )
                }
            } header: {
                Text(year)
            }
        }
    }

    func workoutsCountSection(for workouts: [HKWorkout]) -> some View {
        Section {} footer: {
            HStack {
                Spacer()
                Text(.init("\(formatting: workouts.count) \("workouts".localized)"))
                Spacer()
            }
        }
    }
}

private extension WorkoutsView {
    func initialFetch() async {
        guard !initiaLoadHasBeenDone else { return }
        initiaLoadHasBeenDone = true
        await requestFetch()
    }

    func requestFetch() async {
        guard !loading else { return }
        loading = true

        guard healthKitHelper.isHealthDataAvailable() else {
            loading = false
            state = .unavailable
            return
        }

        do {
            try await healthKitHelper.requestAuthorization()
            await fetchWorkouts()
        } catch {
            loading = false
            state = .unauthorized
        }
    }

    func fetchWorkouts() async {
        do {
            let workouts = try await healthKitHelper.fetchWorkouts()
            loading = false
            state = .results(workouts)
        } catch {
            loading = false
            state = .failedFetch
        }
    }

    func splitWorkoutsByYear(_ workouts: [HKWorkout]) -> [String: [HKWorkout]] {
        var output = [String: [HKWorkout]]()
        for workout in workouts {
            let year = "\(workout.endDate.year)"
            var collection = output[year] ?? [HKWorkout]()
            collection.append(workout)
            output[year] = collection
        }
        return output
    }
}

#if DEBUG
    struct WorkoutsView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                WorkoutsView(
                    healthKitHelper: MockHealthKitHelper()
                )
            }
        }
    }
#endif
