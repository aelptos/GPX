//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit

struct MapViewUserButton {
    static func addButton(to mapView: MKMapView) {
        let userButtonContainer = UIView()
        mapView.addSubview(userButtonContainer)
        userButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        userButtonContainer.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        userButtonContainer.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        userButtonContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userButtonContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userButtonContainer.layer.cornerRadius = 5
        userButtonContainer.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = userButtonContainer.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userButtonContainer.addSubview(blurredEffectView)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = userButtonContainer.bounds
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.contentView.addSubview(vibrancyEffectView)

        let userButton = MKUserTrackingButton(mapView: mapView)
        userButton.frame = userButtonContainer.bounds
        userButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyEffectView.contentView.addSubview(userButton)
    }
}
