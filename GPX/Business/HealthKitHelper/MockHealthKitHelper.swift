//
//  Copyright © Aelptos. All rights reserved.
//

import CoreLocation
import Foundation
import HealthKit

struct MockHealthKitHelper {}

extension MockHealthKitHelper: HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool {
        true
    }

    func requestAuthorization() async throws {
        return
    }

    func fetchWorkouts() async throws -> [HKWorkout] {
        HKWorkout.samples()
    }

    func fetchRoute(for workout: HKWorkout) async throws -> [CLLocation] {
        []
    }
}
