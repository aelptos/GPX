//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

protocol DetailViewProtocol: AnyObject {
    func prepareView()
    func update(with locations: [CLLocation])
}

final class DetailViewController: UIViewController {
    private let presenter: DetailPresenterProtocol
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()

    init(
        presenter: DetailPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailViewProtocol {
    func prepareView() {
        setupNavigation()
        setupMap()
        setupLocationManager()
    }

    func update(with locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.drawRoute(with: locations)
        }
    }
}

private extension DetailViewController {
    func setupNavigation() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
    }

    func setupMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.constraintToAllSides(of: view)
        mapView.delegate = self
        mapView.showsUserLocation = true

        let userButtonContainer = UIView()
        view.addSubview(userButtonContainer)
        userButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        userButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        userButtonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        userButtonContainer.widthAnchor.constraint(equalToConstant: 42).isActive = true
        userButtonContainer.heightAnchor.constraint(equalToConstant: 42).isActive = true
        userButtonContainer.layer.cornerRadius = 5
        userButtonContainer.backgroundColor = .systemBackground.withAlphaComponent(0.8)

        let userButton = MKUserTrackingButton(mapView: mapView)
        userButtonContainer.addSubview(userButton)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.centerXAnchor.constraint(equalTo: userButtonContainer.centerXAnchor).isActive = true
        userButton.centerYAnchor.constraint(equalTo: userButtonContainer.centerYAnchor).isActive = true
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func drawRoute(with locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        let coordinates = locations.map { $0.coordinate }
        let routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(routeOverlay, level: .aboveRoads)
        let customEdgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
        mapView.setVisibleMapRect(routeOverlay.boundingMapRect, edgePadding: customEdgePadding, animated: true)
    }
}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([
            UIColor(red: 0.02, green: 0.91, blue: 0.05, alpha: 1.00)
        ], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 4.0
        return renderer
    }
}
