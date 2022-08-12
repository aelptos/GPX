//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func didRequestFetch()
    func didSelect(_ workout: WorkoutViewModel)
}

final class HomePresenter {
    weak var view: HomeViewProtocol?

    private let router: RouterProtocol
    private let healthKitHelper: HealthKitHelperProtocol
    private var processing = false {
        didSet {
            if processing {
                router.showProgress()
            } else {
                router.hideProgress()
            }
        }
    }

    init(
        router: RouterProtocol,
        healthKitHelper: HealthKitHelperProtocol
    ) {
        self.router = router
        self.healthKitHelper = healthKitHelper
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        view?.prepareView()
        view?.update(.initial)
    }

    func didRequestFetch() {
        guard !processing else { return }
        processing = true

        guard healthKitHelper.isHealthDataAvailable() else {
            processing = false
            view?.update(.unavailable)
            return
        }

        healthKitHelper.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.processing = false
                self.view?.update(.unauthorized)
            case let .success(status):
                guard status else {
                    self.processing = false
                    self.view?.update(.unauthorized)
                    return
                }
                self.fetchWorkouts()
            }
        }
    }

    func didSelect(_ workout: WorkoutViewModel) {
        router.showDetail(for: workout)
    }
}

private extension HomePresenter {
    func fetchWorkouts() {
        healthKitHelper.fetchWorkouts { [weak self] result in
            guard let self = self else { return }
            self.processing = false
            switch result {
            case .failure:
                self.view?.update(.failedFetch)
            case let .success(workouts):
                self.view?.update(.results(WorkoutViewModelBuilder.build(with: workouts)))
            }
        }
    }
}
