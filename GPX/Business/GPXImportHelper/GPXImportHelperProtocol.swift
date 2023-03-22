//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPXImportHelperProtocol {
    static func importGPX(from fileUrl: URL) throws -> [CLLocationCoordinate2D]
}
