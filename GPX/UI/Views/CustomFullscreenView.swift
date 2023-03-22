//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct CustomFullscreenView<Content, FullscreenView>: View where Content: View, FullscreenView: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let fullscreenView: () -> FullscreenView

    var body: some View {
        content()
            .overlay(isPresented ? fullscreenView() : nil)
    }
}

extension View {
    func customFullscreenView<FullscreenView>(
        isPresented: Binding<Bool>,
        fullscreenView: @escaping () -> FullscreenView
    ) -> some View where FullscreenView: View {
        CustomFullscreenView(
            isPresented: isPresented,
            content: { self },
            fullscreenView: fullscreenView
        )
    }
}
