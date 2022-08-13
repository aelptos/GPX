//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

enum HomeViewModel {
    case initial
    case unavailable
    case unauthorized
    case failedFetch
    case results([String: [HKWorkout]])
}
