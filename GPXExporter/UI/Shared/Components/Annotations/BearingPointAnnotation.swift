//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import MapKit

final class BearingPointAnnotation: MKPointAnnotation {
    let direction: CLLocationDirection

    init(direction: CLLocationDirection) {
        self.direction = direction
    }
}
