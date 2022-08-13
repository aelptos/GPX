//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

protocol InfoViewProtocol: AnyObject {
    func prepareView()
}

final class InfoViewController: UIViewController {
    private let presenter: InfoPresenterProtocol

    init(
        presenter: InfoPresenterProtocol
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

extension InfoViewController: InfoViewProtocol {
    func prepareView() {
        view.backgroundColor = .systemBackground
        setupNavigation()
    }
}

private extension InfoViewController {
    func setupNavigation() {
        title = "info.title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "close".localized,
            style: .plain,
            target: self,
            action: #selector(onCloseButtonTap)
        )
    }

    @objc func onCloseButtonTap() {
        presenter.didRequestClose()
    }
}
