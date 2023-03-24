//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct GPXActivityView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<GPXActivityView>) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<GPXActivityView>) {}
}
