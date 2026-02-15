import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataStore: ColivingDataStore
    @AppStorage("savedColivings") private var savedData: Data = Data()
    
    var savedIds: Set<String> {
        (try? JSONDecoder().decode(Set<String>.self, from: savedData)) ?? []
    }
    
    var savedColivings: [Coliving] {
        dataStore.colivings.filter { savedIds.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if savedColivings.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("No saved spaces yet")
                            .font(.title3.weight(.medium))
                        Text("Tap the heart icon on any co-living to save it here.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(savedColivings) { coliving in
                                NavigationLink(destination: ColivingDetailView(coliving: coliving)) {
                                    ColivingCard(coliving: coliving)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Saved")
        }
    }
}
