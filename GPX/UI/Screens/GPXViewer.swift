//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct GPXViewer: View {
    private enum ScreenState {
        case noRoute
        case route
    }

    @EnvironmentObject var appState: AppState

    @State private var state: ScreenState = .noRoute
    @State private var route: MKPolyline?
    @State private var importFile = false
    @State private var importError = false
    @State private var coordinates: [CLLocationCoordinate2D]?

    var body: some View {
        VStack {
            switch state {
            case .noRoute:
                VStack(spacing: 16) {
                    Spacer()
                    Text("viewer.empty.title".localized)
                        .font(.title)
                    VStack {
                        Text(.init("viewer.empty.subtitle".localized))
                        HStack {
                            Text("viewer.empty.subtitle.use".localized)
                            Image(systemName: "ellipsis.circle.fill")
                            Text("viewer.empty.subtitle.menu".localized)
                        }
                    }
                    .font(.callout)
                    .foregroundColor(.secondary)
                    Spacer()
                    Spacer()
                }
            case .route:
                MapView(
                    route: $route,
                    userInteractionEnabled: true,
                    padding: 50,
                    showUserLocation: true
                )
                .ignoresSafeArea()
                .safeAreaInset(edge: .top) {
                    Color.clear
                        .frame(height: 0)
                        .background(.ultraThinMaterial)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear
                        .frame(height: 0)
                        .background(.ultraThinMaterial)
                }
            }
        }
        .navigationTitle("viewer.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        importFile.toggle()
                    } label: {
                        Label(
                            "viewer.empty.actions.import".localized,
                            systemImage: "square.and.arrow.down"
                        )
                    }
                    if route != nil {
                        Button {
                            clear()
                        } label: {
                            Label(
                                "viewer.empty.actions.clear".localized,
                                systemImage: "trash"
                            )
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                }
            }
        }
        .alert("error".localized, isPresented: $importError) {
            Button("ok".localized, role: .cancel) {}
        } message: {
            Text("viewer.import.error".localized)
        }
        .fileImporter(isPresented: $importFile, allowedContentTypes: [.init(filenameExtension: "gpx")!]) { result in
            do {
                let fileUrl = try result.get()
                try importGPX(from: fileUrl, secure: true)
            } catch {
                importError.toggle()
            }
        }
        .onChange(of: appState.openUrl) { url in
            guard let url = url else {
                importError.toggle()
                return
            }
            do {
                try importGPX(from: url, secure: false)
            } catch {
                importError.toggle()
            }
        }
    }
}

private extension GPXViewer {
    func importGPX(from url: URL, secure: Bool) throws {
        let coordinates = try GPXImportHelper.importGPX(from: url, secure: secure)
        self.coordinates = coordinates
        route = MKPolyline(
            coordinates: coordinates,
            count: coordinates.count
        )
        state = .route
    }

    func clear() {
        state = .noRoute
        route = nil
        coordinates = nil
    }
}

#if DEBUG
    struct GPXViewer_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                GPXViewer()
            }
        }
    }
#endif
