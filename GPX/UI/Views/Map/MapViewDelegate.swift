//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit

final class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIView().tintColor
        renderer.lineCap = .round
        renderer.lineWidth = 5.0
        return renderer
    }

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        if let identifiableAnnotation = annotation as? IdentifiablePointAnnotation {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            switch identifiableAnnotation.identifier {
            case AnnotationTitle.start.rawValue:
                annotationView.markerTintColor = .green
                annotationView.glyphImage = UIImage(systemName: "flag.checkered")
            case AnnotationTitle.finish.rawValue:
                annotationView.markerTintColor = .red
                annotationView.glyphImage = UIImage(systemName: "flag.checkered.2.crossed")
            default:
                break
            }
            return annotationView
        }
        if let bearingAnnotation = annotation as? BearingPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "bearingAnnotation")
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = UIImage(systemName: "location.north.fill")
            imageView.tintColor = UIView().traitCollection.userInterfaceStyle == .dark ? .white : .lightGray
            annotationView.addSubview(imageView)
            let direction = bearingAnnotation.direction
            let offset = direction > 180 ? 10 : -10
            annotationView.transform = CGAffineTransformMakeRotation(degreesToRadians(CGFloat(direction)))
            annotationView.centerOffset = CGPoint(x: 0, y: offset)
            return annotationView
        }
        return nil
    }
}

private extension MapViewDelegate {
    func degreesToRadians(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
}
