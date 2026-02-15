import Foundation
import Combine

class ColivingDataStore: ObservableObject {
    @Published var colivings: [Coliving] = []
    @Published var searchText: String = ""
    @Published var selectedRegion: String? = nil
    @Published var selectedWifiQuality: WifiRating? = nil
    @Published var maxPrice: Double? = nil
    @Published var selectedAmenities: Set<String> = []
    
    var regions: [String] {
        Array(Set(colivings.map { $0.country })).sorted()
    }
    
    var allAmenities: [String] {
        Array(Set(colivings.flatMap { $0.amenities })).sorted()
    }
    
    var filteredColivings: [Coliving] {
        colivings.filter { coliving in
            // Search text
            if !searchText.isEmpty {
                let query = searchText.lowercased()
                let matches = coliving.name.lowercased().contains(query) ||
                    coliving.city.lowercased().contains(query) ||
                    coliving.country.lowercased().contains(query) ||
                    coliving.description.lowercased().contains(query)
                if !matches { return false }
            }
            
            // Region filter
            if let region = selectedRegion, !region.isEmpty {
                if coliving.country != region { return false }
            }
            
            // WiFi filter
            if let wifi = selectedWifiQuality {
                if coliving.wifiRating != wifi { return false }
            }
            
            // Price filter
            if let max = maxPrice {
                if let price = coliving.priceFrom, price > max { return false }
            }
            
            // Amenity filter
            if !selectedAmenities.isEmpty {
                let has = Set(coliving.amenities)
                if !selectedAmenities.isSubset(of: has) { return false }
            }
            
            return true
        }
        .sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "colivings", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load colivings.json")
            return
        }
        
        do {
            colivings = try JSONDecoder().decode([Coliving].self, from: data)
        } catch {
            print("Failed to decode colivings: \(error)")
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedRegion = nil
        selectedWifiQuality = nil
        maxPrice = nil
        selectedAmenities = []
    }
    
    var hasActiveFilters: Bool {
        selectedRegion != nil || selectedWifiQuality != nil || maxPrice != nil || !selectedAmenities.isEmpty
    }
}
