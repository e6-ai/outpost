import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: ColivingDataStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            MapExploreView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Label("Saved", systemImage: "heart")
                }
                .tag(2)
        }
        .tint(.primary)
    }
}
