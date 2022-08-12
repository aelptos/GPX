//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

protocol DetailViewProtocol: AnyObject {
    func prepareView()
}

final class DetailViewController: UIViewController {
    private let presenter: DetailPresenterProtocol
    private var locationManager = CLLocationManager()

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
}

private extension DetailViewController {
    func setupNavigation() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
    }

    func setupMap() {
        let mapView = MKMapView(frame: .zero)
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.constraintToAllSides(of: view)
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
