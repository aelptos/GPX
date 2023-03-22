//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreGPX
import CoreLocation

struct GPXImportHelper {
    enum ImportError: Swift.Error {
        case accessDenied
        case failedParsing
        case noCoordinates
    }
}

extension GPXImportHelper: GPXImportHelperProtocol {
    static func importGPX(from fileUrl: URL) throws -> [CLLocationCoordinate2D] {
        guard fileUrl.startAccessingSecurityScopedResource() else {
            throw ImportError.accessDenied
        }
        guard let gpx = GPXParser(withURL: fileUrl)?.parsedData() else {
            throw ImportError.failedParsing
        }
        fileUrl.stopAccessingSecurityScopedResource()
        var coordinates: [CLLocationCoordinate2D] = []
        for track in gpx.tracks {
            for segment in track.segments {
                for trackPoint in segment.points {
                    guard let coordinate = trackPoint.coordinate else { continue }
                    coordinates.append(coordinate)
                }
            }
        }
        guard !coordinates.isEmpty else {
            throw ImportError.noCoordinates
        }
        return coordinates
    }
}
