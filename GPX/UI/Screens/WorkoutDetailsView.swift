//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI
import HealthKit
import MapKit

struct WorkoutDetailsView: View {
    private enum ScreenState {
        case initial
        case failedFetch
        case noRoute
        case results([CLLocation])
    }

    @State private var state: ScreenState = .initial
    @State private var route: MKPolyline?
    @State private var locations: [CLLocation]?
    @State private var shareError = false
    @State private var isFullscreenMapShown = false
    @Namespace private var mapAnimation

    let healkitHelper: HealthKitHelperProtocol
    let workout: HKWorkout

    var body: some View {
        GeometryReader { geometry in
            switch state {
            case .initial:
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            case .failedFetch:
                MessageView(
                    text: "detail.route.fetch.error".localized,
                    icon: "road.lanes"
                )
                .frame(maxWidth: .infinity)
            case .noRoute:
                MessageView(
                    text: "detail.route.empty".localized,
                    icon: "road.lanes"
                )
                .frame(maxWidth: .infinity)
            case .results:
                VStack {
                    HStack {
                        Spacer()
                        MapView(route: $route, userInteractionEnabled: false,
                                padding: 10, showUserLocation: false)
                            .matchedGeometryEffect(id: "map", in: mapAnimation)
                            .frame(
                                width: geometry.size.width * 0.9,
                                height: 200
                            )
                            .cornerRadius(8)
                            .padding(.top)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    isFullscreenMapShown.toggle()
                                }
                            }
                        Spacer()
                    }
                    WorkoutView(workout: workout)
                        .padding([.leading, .trailing])
                }
            }
        }
        .task {
            await fetchRoute()
        }
        .navigationTitle("detail.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .if(locations != nil) { view in
            view.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onShare()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .alert("error".localized, isPresented: $shareError) {
            Button("ok".localized, role: .cancel) {}
        } message: {
            Text("detail.gpx.export.error".localized)
        }
        .customFullscreenView(isPresented: $isFullscreenMapShown) {
            RouteView(
                route: $route,
                isPresented: $isFullscreenMapShown,
                mapAnimation: mapAnimation
            )
        }
        .navigationBarHidden($isFullscreenMapShown.wrappedValue)
    }
}

private extension WorkoutDetailsView {
    func fetchRoute() async {
        do {
            let locations = try await healkitHelper.fetchRoute(for: workout)
            guard !locations.isEmpty else {
                state = .noRoute
                return
            }
            self.locations = locations
            makeRoute(with: locations)
            state = .results(locations)
        } catch {
            state = .failedFetch
        }
    }

    func makeRoute(with locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        route = MKPolyline(
            coordinates: coordinates,
            count: coordinates.count
        )
    }

    func onShare() {
        guard let locations = locations else { return }
        do {
            let path = try GPXExportHelper.export(locations)
            UIActivityViewController.show(with: path)
        } catch {
            shareError.toggle()
        }
    }
}

#if DEBUG
    struct WorkoutDetailsView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                WorkoutDetailsView(
                    healkitHelper: MockHealthKitHelper(),
                    workout: HKWorkout.sample(for: .cycling)
                )
            }
        }
    }
#endif
