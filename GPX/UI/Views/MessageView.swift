//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    let text: String
    let icon: String?

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 80))
                    .padding(.top, 32)
            }
            Text(.init(text))
                .multilineTextAlignment(.center)
        }
    }
}

#if DEBUG
    struct MessageView_Previews: PreviewProvider {
        static var previews: some View {
            MessageView(
                text: "**Hello** world",
                icon: "exclamationmark.triangle"
            )
        }
    }
#endif
