import SwiftUI

@main
struct ColivingFinderApp: App {
    @StateObject private var dataStore = ColivingDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
