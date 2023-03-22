//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct MapViewAnnotationsHelper {
    static func addStartAndFinishPins(
        on mapView: MKMapView,
        with coordinates: [CLLocationCoordinate2D]
    ) {
        guard coordinates.count >= 2 else { return }
        addPin(for: coordinates.first, title: .start, on: mapView)
        addPin(for: coordinates.last, title: .finish, on: mapView)
    }

    // See https://stackoverflow.com/questions/17829611/how-to-draw-an-arrow-between-two-points-on-the-map-mapkit
    static func addDirectionArrows(
        on mapView: MKMapView,
        with coordinates: [CLLocationCoordinate2D]
    ) {
        guard !coordinates.isEmpty else { return }
        let coordinatesCount = coordinates.count
        guard coordinatesCount > 10 else { return }
        let stepsCount = 10
        for index in 1 ..< stepsCount {
            let index = (coordinatesCount / stepsCount) * index
            let previous = coordinates[index - 1]
            let current = coordinates[index]

            let deltaLong = current.longitude - previous.longitude
            let yComponent = sin(deltaLong) * cos(current.latitude)
            let xComponent = (cos(previous.latitude) * sin(current.latitude)) - (sin(previous.latitude) * cos(current.latitude) * cos(deltaLong))
            let radians = atan2(yComponent, xComponent)
            let degrees = radiansToDegrees(radians) + 360
            let direction = fmod(degrees, 360)

            let annotation = BearingPointAnnotation(direction: direction)
            annotation.coordinate = current
            mapView.addAnnotation(annotation)
        }
    }
}

private extension MapViewAnnotationsHelper {
    static func addPin(
        for coordinate: CLLocationCoordinate2D?,
        title: AnnotationTitle,
        on mapView: MKMapView
    ) {
        guard let coordinate = coordinate else { return }
        let annotation = IdentifiablePointAnnotation(identifier: title.rawValue)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    static func radiansToDegrees(_ number: CGFloat) -> CGFloat {
        return number * 180 / .pi
    }
}
