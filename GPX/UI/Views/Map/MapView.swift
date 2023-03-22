//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var route: MKPolyline?
    let userInteractionEnabled: Bool
    let padding: CGFloat
    let showUserLocation: Bool

    private let mapViewDelegate = MapViewDelegate()
    private let locationManagerHelper = MapViewLocationManagerHelper()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.isZoomEnabled = userInteractionEnabled
        mapView.isPitchEnabled = userInteractionEnabled
        mapView.isRotateEnabled = userInteractionEnabled
        mapView.isScrollEnabled = userInteractionEnabled
        if showUserLocation {
            mapView.showsUserLocation = true
            locationManagerHelper.setupLocationManager()
            MapViewAnnotationsHelper.addStartAndFinishPins(
                on: mapView,
                with: route?.coordinates ?? []
            )
            MapViewAnnotationsHelper.addDirectionArrows(
                on: mapView,
                with: route?.coordinates ?? []
            )
            MapViewUserButton.addButton(to: mapView)
        }
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.delegate = mapViewDelegate
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addRoute(to: mapView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            adjustMapVisibleRect(mapView, for: route)
        }
    }
}

private extension MapView {
    func addRoute(to mapView: MKMapView) {
        guard let route = route else { return }
        if !mapView.overlays.isEmpty {
            mapView.removeOverlays(mapView.overlays)
        }
        mapView.addOverlay(route, level: .aboveRoads)
        adjustMapVisibleRect(mapView, for: route)
    }

    func adjustMapVisibleRect(_ mapView: MKMapView, for route: MKPolyline?) {
        guard let route = route else { return }
        let edgePadding = UIEdgeInsets(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        mapView.setVisibleMapRect(
            route.boundingMapRect,
            edgePadding: edgePadding,
            animated: true
        )
    }
}
