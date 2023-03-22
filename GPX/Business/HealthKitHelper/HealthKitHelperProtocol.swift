//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit
import CoreLocation

protocol HealthKitHelperProtocol {
    func isHealthDataAvailable() -> Bool
    func requestAuthorization() async throws
    func fetchWorkouts() async throws -> [HKWorkout]
    func fetchRoute(for workout: HKWorkout) async throws -> [CLLocation]
}
