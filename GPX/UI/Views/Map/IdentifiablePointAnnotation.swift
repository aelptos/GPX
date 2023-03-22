//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import MapKit

final class IdentifiablePointAnnotation: MKPointAnnotation {
    let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }
}
