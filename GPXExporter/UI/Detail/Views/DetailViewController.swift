//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import HealthKit

protocol DetailViewProtocol: AnyObject {
    func prepareView()
}

final class DetailViewController: UIViewController {
    private let presenter: DetailPresenterProtocol

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
    }
}

private extension DetailViewController {
    func setupNavigation() {
        title = "Detail"
    }
}
