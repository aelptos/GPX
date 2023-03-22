//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

@main
struct GPXApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    GPXViewer()
                }
                .tabItem {
                    Label("viewer.title".localized, systemImage: "map")
                }
                NavigationStack {
                    WorkoutsView(healthKitHelper: HealthKitHelper())
                }
                .tabItem {
                    Label("workouts.title".localized, systemImage: "figure.run")
                }
            }
        }
    }
}
