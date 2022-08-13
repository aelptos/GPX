//
//  Copyright © Aelptos. All rights reserved.
//

import Foundation

protocol InfoPresenterProtocol {
    func viewDidLoad()
    func didRequestClose()
}

final class InfoPresenter {
    weak var view: InfoViewProtocol?

    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }
}

extension InfoPresenter: InfoPresenterProtocol {
    func viewDidLoad() {
        view?.prepareView()
    }

    func didRequestClose() {
        router.hideInfo()
    }
}
