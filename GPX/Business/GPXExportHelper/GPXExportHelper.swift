//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreLocation

struct GPXExportHelper {
    enum Error: Swift.Error {
        case couldNotGetFilepath
    }
}

extension GPXExportHelper: GPXExportHelperProtocol {
    static func export(_ locations: [CLLocation]) throws -> URL {
        let fileName = "\(UUID().uuidString).gpx"
        guard let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) else {
            throw Error.couldNotGetFilepath
        }
        var gpxText = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\" creator=\"GPXEporter\" xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:gte=\"http://www.gpstrackeditor.com/xmlschemas/General/1\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">"
        gpxText.append("<trk><trkseg>")
        for location in locations {
            gpxText.append("<trkpt lat=\"\(String(format: "%.6f", location.coordinate.latitude))\" lon=\"\(String(format: "%.6f", location.coordinate.longitude))\"><ele>\(location.altitude)</ele><time>\(String(describing: location.timestamp))</time></trkpt>")
        }
        gpxText.append("</trkseg></trk></gpx>")
        try gpxText.write(to: path, atomically: true, encoding: .utf8)
        return path
    }
}
