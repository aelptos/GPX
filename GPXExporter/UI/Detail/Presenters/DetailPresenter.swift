//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation
import HealthKit

protocol DetailPresenterProtocol {
    func viewDidLoad()
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?

    private let router: RouterProtocol
    private let healthKitHelper: HealthKitHelperProtocol
    private let workout: HKWorkout

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
        view?.prepareView()
        fetchRoute()
    }
}

private extension DetailPresenter {
    func fetchRoute() {
        healthKitHelper.fetchRoute(for: workout) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.router.showError("Failed to fetch route")
            case let .success(locations):
                self.view?.update(with: locations)
            }
        }
    }
}
