import Foundation
import CoreLocation

struct Coliving: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let country: String
    let region: String
    let latitude: Double?
    let longitude: Double?
    let priceFrom: Double?
    let priceTo: Double?
    let currency: String
    let priceUnit: String
    let website: String?
    let rating: Double?
    let reviewCount: Int?
    let amenities: [String]
    let wifiQuality: String?
    let description: String
    let imageUrl: String?
    let source: String
    let photos: [String]
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lng = longitude, lat != 0, lng != 0 else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var priceDisplay: String {
        guard let from = priceFrom else { return "Contact for pricing" }
        let symbol = currency == "USD" ? "$" : "€"
        if let to = priceTo, to != from {
            return "\(symbol)\(Int(from))–\(symbol)\(Int(to))/\(priceUnit)"
        }
        return "From \(symbol)\(Int(from))/\(priceUnit)"
    }
    
    var wifiRating: WifiRating {
        WifiRating(rawValue: wifiQuality ?? "unknown") ?? .unknown
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Coliving, rhs: Coliving) -> Bool {
        lhs.id == rhs.id
    }
}

enum WifiRating: String, Codable, CaseIterable {
    case excellent, good, average, poor, unknown
    
    var label: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .average: return "Average"
        case .poor: return "Poor"
        case .unknown: return "Unknown"
        }
    }
    
    var icon: String {
        switch self {
        case .excellent: return "wifi"
        case .good: return "wifi"
        case .average: return "wifi.exclamationmark"
        case .poor: return "wifi.slash"
        case .unknown: return "questionmark.circle"
        }
    }
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .average: return "orange"
        case .poor: return "red"
        case .unknown: return "gray"
        }
    }
}
