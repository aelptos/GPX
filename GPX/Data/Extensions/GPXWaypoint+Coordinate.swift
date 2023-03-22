//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreGPX
import CoreLocation

extension GPXWaypoint {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude,
              let longitude = longitude else { return nil }
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
