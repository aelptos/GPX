//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    Image("Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color(UIColor.label))
                        )
                    Text("app.name".localized)
                        .font(.title)
                }
                .padding([.top, .bottom], 32)
                VStack {
                    Text("info.description".localized)
                    Text("info.credits.title".localized)
                        .font(.subheadline)
                        .padding(.top, 32)
                        .padding(.bottom, 8)
                    Text("info.credits".localized)
                        .font(.footnote)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .background(Color(UIColor.systemBackground))
            .previewLayout(.fixed(width: 376, height: 600))
    }
}
