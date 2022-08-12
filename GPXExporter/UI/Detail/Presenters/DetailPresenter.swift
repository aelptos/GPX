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
    private let workout: HKWorkout

    init(
        router: RouterProtocol,
        workout: HKWorkout
    ) {
        self.router = router
        self.workout = workout
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        view?.prepareView()
    }
}
