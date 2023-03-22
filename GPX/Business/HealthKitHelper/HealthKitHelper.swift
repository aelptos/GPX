//
//  Copyright © Aelptos. All rights reserved.
//

import CoreLocation
import Foundation
import HealthKit

final class HealthKitHelper {
    private lazy var store = HKHealthStore()
}

extension HealthKitHelper: HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async throws {
        try await store.requestAuthorization(toShare: [], read: [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ])
    }

    func fetchWorkouts() async throws -> [HKWorkout] {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKWorkout], Error>) in
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                HKQuery.predicateForWorkouts(with: .cycling),
                HKQuery.predicateForWorkouts(with: .hiking),
                HKQuery.predicateForWorkouts(with: .running),
                HKQuery.predicateForWorkouts(with: .walking)
            ])
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    .init(keyPath: \HKSample.startDate, ascending: false)
                ]
            ) { [weak self] (query, results, error) in
                guard self != nil else { return }
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let workouts = results as? [HKWorkout] else {
                    continuation.resume(returning: [])
                    return
                }
                let filteredWorkouts = workouts.filter { workout in
                    workout.totalDistance?.doubleValue(for: .meter()) ?? 0 > 0
                }
                continuation.resume(returning: filteredWorkouts)
            }
            store.execute(query)
        }
    }

    func fetchRoute(for workout: HKWorkout) async throws -> [CLLocation] {
        let route = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKWorkoutRoute?, Error>) in
            let predicate = HKQuery.predicateForObjects(from: workout)
            let query = HKAnchoredObjectQuery(
                type: HKSeriesType.workoutRoute(),
                predicate: predicate,
                anchor: nil,
                limit: HKObjectQueryNoLimit
            ) { [weak self] (query, results, deletedObjects, anchor, error) in
                guard self != nil else { return }
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: (results as? [HKWorkoutRoute])?.first)
            }
            store.execute(query)
        }
        guard let route = route else { return [] }
        return try await fetchLocations(with: route)
    }
}

private extension HealthKitHelper {
    func fetchLocations(with route: HKWorkoutRoute) async throws -> [CLLocation] {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var output = [CLLocation]()
            let query = HKWorkoutRouteQuery(
                route: route
            ) { [weak self] (query, locations, done, error) in
                guard self != nil else { return }
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                if let locations = locations {
                    output.append(contentsOf: locations)
                }
                if done {
                    continuation.resume(returning: output)
                }
            }
            store.execute(query)
        }
    }
}
