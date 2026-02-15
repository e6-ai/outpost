import SwiftUI
import MapKit

struct ColivingDetailView: View {
    let coliving: Coliving
    @State private var isSaved = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                AsyncImage(url: URL(string: coliving.imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "building.2")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.secondary)
                            }
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay(ProgressView())
                    }
                }
                .frame(height: 280)
                .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(coliving.name)
                                .font(.title2.weight(.bold))
                            Spacer()
                            Button {
                                isSaved.toggle()
                            } label: {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundStyle(isSaved ? .red : .secondary)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                            Text("\(coliving.city), \(coliving.country)")
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
                        
                        if let rating = coliving.rating {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { i in
                                    Image(systemName: Double(i) < rating ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundStyle(.yellow)
                                }
                                Text(String(format: "%.1f", rating))
                                    .font(.subheadline.weight(.medium))
                                if let count = coliving.reviewCount {
                                    Text("· \(count) reviews")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Price section
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Pricing", systemImage: "creditcard")
                            .font(.headline)
                        
                        Text(coliving.priceDisplay)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    
                    Divider()
                    
                    // WiFi section
                    VStack(alignment: .leading, spacing: 8) {
                        Label("WiFi Quality", systemImage: "wifi")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            WifiBadge(quality: coliving.wifiRating)
                            
                            Text(wifiDescription)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Label("About", systemImage: "info.circle")
                            .font(.headline)
                        
                        Text(coliving.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    // Amenities
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Amenities", systemImage: "checkmark.circle")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(coliving.amenities, id: \.self) { amenity in
                                HStack(spacing: 6) {
                                    Image(systemName: amenityIcon(for: amenity))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 16)
                                    Text(amenity)
                                        .font(.subheadline)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // Map
                    if let coordinate = coliving.coordinate {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Location", systemImage: "map")
                                .font(.headline)
                            
                            Map(initialPosition: .region(MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            ))) {
                                Marker(coliving.name, coordinate: coordinate)
                                    .tint(.red)
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        if let website = coliving.website, let url = URL(string: website) {
                            Link(destination: url) {
                                HStack {
                                    Text("Visit Website")
                                        .font(.headline)
                                    Image(systemName: "arrow.up.right")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primary)
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        ShareLink(item: coliving.website ?? coliving.name) {
                            HStack {
                                Text("Share")
                                    .font(.headline)
                                Image(systemName: "square.and.arrow.up")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .foregroundStyle(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    var wifiDescription: String {
        switch coliving.wifiRating {
        case .excellent: return "Fast, reliable connection suitable for video calls"
        case .good: return "Reliable for most remote work needs"
        case .average: return "Works for basic tasks, may struggle with video"
        case .poor: return "Limited connectivity, consider backup options"
        case .unknown: return "WiFi quality not yet verified"
        }
    }
    
    func amenityIcon(for amenity: String) -> String {
        let lower = amenity.lowercased()
        if lower.contains("wifi") { return "wifi" }
        if lower.contains("pool") { return "figure.pool.swim" }
        if lower.contains("gym") { return "dumbbell" }
        if lower.contains("kitchen") { return "fork.knife" }
        if lower.contains("coworking") || lower.contains("desk") { return "desktopcomputer" }
        if lower.contains("beach") { return "beach.umbrella" }
        if lower.contains("garden") { return "leaf" }
        if lower.contains("laundry") { return "washer" }
        if lower.contains("event") { return "person.3" }
        if lower.contains("surf") { return "figure.surfing" }
        if lower.contains("yoga") { return "figure.yoga" }
        if lower.contains("bike") || lower.contains("bicycle") { return "bicycle" }
        if lower.contains("parking") { return "car" }
        if lower.contains("pet") { return "pawprint" }
        if lower.contains("coffee") { return "cup.and.saucer" }
        if lower.contains("rooftop") { return "building.2" }
        if lower.contains("fireplace") { return "flame" }
        if lower.contains("mountain") { return "mountain.2" }
        if lower.contains("hiking") { return "figure.hiking" }
        if lower.contains("restaurant") || lower.contains("bar") { return "wineglass" }
        return "checkmark"
    }
}
