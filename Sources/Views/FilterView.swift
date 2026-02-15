import SwiftUI

struct FilterView: View {
    @EnvironmentObject var dataStore: ColivingDataStore
    @Environment(\.dismiss) var dismiss
    @State private var tempRegion: String? = nil
    @State private var tempWifi: WifiRating? = nil
    @State private var tempMaxPrice: Double = 200
    @State private var priceEnabled = false
    @State private var tempAmenities: Set<String> = []
    
    var body: some View {
        NavigationStack {
            Form {
                // Region
                Section("Region") {
                    Picker("Country", selection: $tempRegion) {
                        Text("All Countries").tag(nil as String?)
                        ForEach(dataStore.regions, id: \.self) { region in
                            Text(region).tag(region as String?)
                        }
                    }
                }
                
                // WiFi Quality
                Section("WiFi Quality") {
                    Picker("Minimum WiFi", selection: $tempWifi) {
                        Text("Any").tag(nil as WifiRating?)
                        Text("🟢 Excellent").tag(WifiRating.excellent as WifiRating?)
                        Text("🔵 Good").tag(WifiRating.good as WifiRating?)
                    }
                    .pickerStyle(.segmented)
                }
                
                // Price
                Section("Max Price per Night") {
                    Toggle("Filter by price", isOn: $priceEnabled)
                    
                    if priceEnabled {
                        VStack(alignment: .leading) {
                            Text("Up to $\(Int(tempMaxPrice))/night")
                                .font(.subheadline.weight(.medium))
                            Slider(value: $tempMaxPrice, in: 10...200, step: 5)
                        }
                    }
                }
                
                // Amenities
                Section("Amenities") {
                    ForEach(["Coworking Space", "Pool", "Gym", "Kitchen", "Beach Nearby", "Events", "Garden", "Surfing", "Yoga"], id: \.self) { amenity in
                        Toggle(amenity, isOn: Binding(
                            get: { tempAmenities.contains(amenity) },
                            set: { isOn in
                                if isOn { tempAmenities.insert(amenity) }
                                else { tempAmenities.remove(amenity) }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        tempRegion = nil
                        tempWifi = nil
                        tempMaxPrice = 200
                        priceEnabled = false
                        tempAmenities = []
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dataStore.selectedRegion = tempRegion
                        dataStore.selectedWifiQuality = tempWifi
                        dataStore.maxPrice = priceEnabled ? tempMaxPrice : nil
                        dataStore.selectedAmenities = tempAmenities
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                tempRegion = dataStore.selectedRegion
                tempWifi = dataStore.selectedWifiQuality
                if let max = dataStore.maxPrice {
                    tempMaxPrice = max
                    priceEnabled = true
                }
                tempAmenities = dataStore.selectedAmenities
            }
        }
    }
}
