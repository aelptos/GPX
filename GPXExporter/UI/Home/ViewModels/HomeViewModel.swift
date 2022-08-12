//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

enum HomeViewModel {
    case initial
    case unavailable
    case unauthorized
    case failedFetch
    case results([WorkoutViewModel])
}
