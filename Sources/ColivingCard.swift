import SwiftUI

struct ColivingCard: View {
    let coliving: Coliving
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
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
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay(ProgressView())
                    }
                }
                .frame(height: 200)
                .clipped()
                
                // WiFi badge
                if let wifi = coliving.wifiQuality, wifi != "unknown" {
                    WifiBadge(quality: coliving.wifiRating)
                        .padding(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Name & Rating
                HStack {
                    Text(coliving.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if let rating = coliving.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.subheadline.weight(.medium))
                            if let count = coliving.reviewCount {
                                Text("(\(count))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(coliving.city), \(coliving.country)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Price
                Text(coliving.priceDisplay)
                    .font(.subheadline.weight(.semibold))
                
                // Amenities preview
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(coliving.amenities.prefix(4), id: \.self) { amenity in
                            Text(amenity)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        if coliving.amenities.count > 4 {
                            Text("+\(coliving.amenities.count - 4)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(14)
        }
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

struct WifiBadge: View {
    let quality: WifiRating
    
    var color: Color {
        switch quality {
        case .excellent: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        case .unknown: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: quality.icon)
                .font(.caption2.weight(.bold))
            Text(quality.label)
                .font(.caption2.weight(.semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(color.opacity(0.9))
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
}
