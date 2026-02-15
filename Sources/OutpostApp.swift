import SwiftUI

@main
struct OutpostApp: App {
    @StateObject private var dataStore = ColivingDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
