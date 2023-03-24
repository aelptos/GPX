//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

@main
struct GPXApp: App {
    @StateObject var state = AppState()
    @State private var selectedTab = "viewer"

    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .phone {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        GPXViewer()
                            .environmentObject(state)
                    }
                    .tabItem {
                        Label("viewer.title".localized, systemImage: "map")
                    }
                    .tag("viewer")

                    NavigationStack {
                        WorkoutsView(healthKitHelper: HealthKitHelper())
                    }
                    .tabItem {
                        Label("workouts.title".localized, systemImage: "figure.run")
                    }
                    .tag("workouts")
                }
                .onOpenURL { url in
                    selectedTab = "viewer"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        state.openUrl = url
                    }
                }
            } else {
                NavigationStack {
                    GPXViewer()
                        .environmentObject(state)
                }
                .onOpenURL { url in
                    state.openUrl = url
                }
            }
        }
    }
}
