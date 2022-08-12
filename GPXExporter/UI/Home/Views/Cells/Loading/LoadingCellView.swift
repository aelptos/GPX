//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct LoadingCellView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .padding()
    }
}

struct LoadingCellView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCellView()
            .previewLayout(.fixed(width: 375, height: 76))
    }
}
