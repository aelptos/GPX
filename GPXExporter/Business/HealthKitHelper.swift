//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchWorkouts(completion: @escaping (Result<[HKWorkout], Error>) -> Void)
    func fetchRoute(for workout: HKWorkout)
}

final class HealthKitHelper {
    private lazy var store = HKHealthStore()
}

extension HealthKitHelper: HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        let allTypes = Set([
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ])
        store.requestAuthorization(toShare: [], read: allTypes) { [weak self] (success, error) in
            guard self != nil else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(success))
        }
    }

    func fetchWorkouts(completion: @escaping (Result<[HKWorkout], Error>) -> Void) {
        let sampleType = HKSampleType.workoutType()
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: nil,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortByDate]
        ) { [weak self] query, results, error in
            guard self != nil else { return }
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let workouts = results as? [HKWorkout] else {
                completion(.success([]))
                return
            }

            completion(.success(workouts))
        }
        store.execute(query)
    }

    func fetchRoute(for workout: HKWorkout) {
        let predicate = HKQuery.predicateForObjects(from: workout)
        let query = HKAnchoredObjectQuery(
            type: HKSeriesType.workoutRoute(),
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { (query, samples, deletedObjects, anchor, error) in
            if let error = error {
                // TODO: handle
                print("The initial query failed: \(error)")
                return
            }

            // Process the initial route data here.
            print("\(String(describing: samples))")
        }
        query.updateHandler = { (query, samples, deleted, anchor, error) in
            if let error = error {
                // TODO: handle
                print("The update query failed: \(error)")
                return
            }

            // Process updates or additions here.
            print("\(String(describing: samples))")
        }
        store.execute(query)
    }
}
