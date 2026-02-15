import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var dataStore: ColivingDataStore
    @State private var showFilters = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search bar
                    SearchBar(text: $dataStore.searchText)
                        .padding(.horizontal)
                    
                    // Quick filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterChip(title: "Filters", icon: "slider.horizontal.3", isActive: dataStore.hasActiveFilters) {
                                showFilters = true
                            }
                            
                            ForEach(["Portugal", "Spain", "Indonesia", "Thailand", "Colombia"], id: \.self) { region in
                                FilterChip(
                                    title: region,
                                    isActive: dataStore.selectedRegion == region
                                ) {
                                    if dataStore.selectedRegion == region {
                                        dataStore.selectedRegion = nil
                                    } else {
                                        dataStore.selectedRegion = region
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Results count
                    HStack {
                        Text("\(dataStore.filteredColivings.count) co-living spaces")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        if dataStore.hasActiveFilters {
                            Button("Clear") {
                                dataStore.clearFilters()
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Listings
                    LazyVStack(spacing: 16) {
                        ForEach(dataStore.filteredColivings) { coliving in
                            NavigationLink(destination: ColivingDetailView(coliving: coliving)) {
                                ColivingCard(coliving: coliving)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("CoLiving Finder")
            .sheet(isPresented: $showFilters) {
                FilterView()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search by city, country, or name...", text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isActive ? Color.primary : Color.clear)
            .foregroundStyle(isActive ? Color(uiColor: .systemBackground) : .primary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.primary.opacity(0.3), lineWidth: 1))
        }
    }
}
