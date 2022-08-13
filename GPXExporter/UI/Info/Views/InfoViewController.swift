//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit
import SwiftUI

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
        setupContent()
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

    func setupContent() {
        let host = UIHostingController(rootView: InfoView())
        addChild(host)
        view.addSubview(host.view)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        host.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        host.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        host.didMove(toParent: self)
    }
}
