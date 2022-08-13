//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit
import CoreLocation

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func didRequestShare()
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?

    private let router: RouterProtocol
    private let healthKitHelper: HealthKitHelperProtocol
    private let workout: HKWorkout
    private var locations: [CLLocation]?

    init(
        router: RouterProtocol,
        healthKitHelper: HealthKitHelperProtocol,
        workout: HKWorkout
    ) {
        self.router = router
        self.healthKitHelper = healthKitHelper
        self.workout = workout
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        view?.prepareView(with: workout)
        fetchRoute()
    }

    func didRequestShare() {
        guard let locations = locations else { return }
        switch Exporter.export(locations) {
        case .failure:
            router.showError("detail.gpx.export.error".localized)
        case let .success(path):
            router.showShare(for: path)
        }
    }
}

private extension DetailPresenter {
    func fetchRoute() {
        healthKitHelper.fetchRoute(for: workout) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.router.showError("detail.route.fetch.error".localized)
            case let .success(locations):
                self.locations = locations
                self.view?.showExportButton()
                self.view?.update(with: locations)
            }
        }
    }
}
