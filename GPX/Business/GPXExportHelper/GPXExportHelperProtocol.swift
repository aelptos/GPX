//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPXExportHelperProtocol {
    static func export(_ locations: [CLLocation]) throws -> URL
}
