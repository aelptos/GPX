//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPXImportHelperProtocol {
    static func importGPX(
        from url: URL,
        secure: Bool
    ) throws -> [CLLocationCoordinate2D]
}
