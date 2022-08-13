//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit
import HealthKit
import SwiftUI

protocol DetailViewProtocol: AnyObject {
    func prepareView(with workout: HKWorkout)
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
    func prepareView(with workout: HKWorkout) {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupMap()
        setupBanner(with: workout)
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
        title = "detail.title".localized
        navigationItem.largeTitleDisplayMode = .never
    }

    func setupMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.delegate = self
        mapView.showsUserLocation = true

        let userButtonContainer = UIView()
        view.addSubview(userButtonContainer)
        userButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        userButtonContainer.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        userButtonContainer.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        userButtonContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userButtonContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userButtonContainer.layer.cornerRadius = 5
        userButtonContainer.backgroundColor = .secondarySystemBackground

        let userButton = MKUserTrackingButton(mapView: mapView)
        userButtonContainer.addSubview(userButton)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.constraintToAllSides(of: userButtonContainer)
    }

    func setupBanner(with workout: HKWorkout) {
        let host = UIHostingController(rootView: WorkoutView(workout: workout))
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        host.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        host.view.heightAnchor.constraint(equalToConstant: 76).isActive = true
        host.didMove(toParent: self)
        host.view.layer.cornerRadius = 16
        host.view.backgroundColor = .secondarySystemBackground
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
        let inset: CGFloat = 50
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
