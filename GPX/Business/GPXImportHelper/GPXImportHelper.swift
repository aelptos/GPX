//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreGPX
import CoreLocation

struct GPXImportHelper {
    enum ImportError: Swift.Error {
        case accessDenied
        case fileDoesNotExist
        case failedParsing
        case noCoordinates
    }
}

extension GPXImportHelper: GPXImportHelperProtocol {
    static func importGPX(
        from url: URL,
        secure: Bool
    ) throws -> [CLLocationCoordinate2D] {
        guard let gpx = secure ? try readSecureFile(at: url) : try readInsecureFile(at: url) else {
            throw ImportError.failedParsing
        }

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

private extension GPXImportHelper {
    static func readSecureFile(at url: URL) throws -> GPXRoot? {
        guard url.startAccessingSecurityScopedResource() else {
            throw ImportError.accessDenied
        }
        let gpx = GPXParser(withURL: url)?.parsedData()
        url.stopAccessingSecurityScopedResource()
        return gpx
    }

    static func readInsecureFile(at url: URL) throws -> GPXRoot? {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ImportError.fileDoesNotExist
        }
        let data = try Data(contentsOf: url)
        let parser = GPXParser(withData: data)
        return parser.parsedData()
    }
}
