//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

protocol DetailViewProtocol: AnyObject {
    func prepareView()
    func update(with locations: [CLLocation])
    func showExportButton()
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

    func showExportButton() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(self.onShareButtonTap)
            )
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
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 5

        let userButtonContainer = UIView()
        view.addSubview(userButtonContainer)
        userButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        userButtonContainer.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        userButtonContainer.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        userButtonContainer.widthAnchor.constraint(equalToConstant: 42).isActive = true
        userButtonContainer.heightAnchor.constraint(equalToConstant: 42).isActive = true
        userButtonContainer.layer.cornerRadius = 5
        userButtonContainer.backgroundColor = .systemBackground.withAlphaComponent(0.5)

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
        let overlay = MKPolyline(
            coordinates: coordinates,
            count: coordinates.count
        )
        mapView.addOverlay(overlay, level: .aboveRoads)
        let inset: CGFloat = 100
        let edgePadding = UIEdgeInsets(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
        mapView.setVisibleMapRect(
            overlay.boundingMapRect,
            edgePadding: edgePadding,
            animated: true
        )
    }

    @objc func onShareButtonTap() {
        presenter.didRequestShare()
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
        renderer.setColors([view.tintColor], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 3.0
        return renderer
    }
}
