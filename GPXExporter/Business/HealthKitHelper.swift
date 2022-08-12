//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchWorkouts(completion: @escaping (Result<[HKWorkout], Error>) -> Void)
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
            HKObjectType.workoutType()
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
}
