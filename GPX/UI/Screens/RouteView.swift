//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @Binding var route: MKPolyline?
    @Binding var isPresented: Bool
    var mapAnimation: Namespace.ID

    var body: some View {
        ZStack {
            MapView(route: $route, userInteractionEnabled: true, padding: 50, showUserLocation: true)
                .matchedGeometryEffect(id: "map", in: mapAnimation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 44))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                Color(UIColor.systemBackground),
                                Color(UIColor.label)
                            )
                    }
                    .padding(.top, 2)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#if DEBUG
    struct RouteView_Previews: PreviewProvider {
        @Namespace static var namespace

        static var previews: some View {
            RouteView(
                route: .constant(nil),
                isPresented: .constant(true),
                mapAnimation: namespace
            )
        }
    }
#endif
