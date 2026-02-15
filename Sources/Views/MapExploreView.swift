import SwiftUI
import MapKit

struct MapExploreView: View {
    @EnvironmentObject var dataStore: ColivingDataStore
    @State private var selectedColiving: Coliving?
    @State private var position: MapCameraPosition = .automatic
    
    var mappableColivings: [Coliving] {
        dataStore.filteredColivings.filter { $0.coordinate != nil }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position, selection: $selectedColiving) {
                    ForEach(mappableColivings) { coliving in
                        if let coord = coliving.coordinate {
                            Marker(coliving.name, coordinate: coord)
                                .tint(markerColor(for: coliving))
                                .tag(coliving)
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                
                // Bottom card when selected
                if let coliving = selectedColiving {
                    NavigationLink(destination: ColivingDetailView(coliving: coliving)) {
                        MapPreviewCard(coliving: coliving)
                    }
                    .buttonStyle(.plain)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: selectedColiving)
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Show All") {
                            position = .automatic
                        }
                        Button("Europe") {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 45, longitude: 10),
                                span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 40)
                            ))
                        }
                        Button("Southeast Asia") {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 5, longitude: 110),
                                span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 40)
                            ))
                        }
                        Button("Americas") {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 15, longitude: -80),
                                span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 50)
                            ))
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                }
            }
        }
    }
    
    func markerColor(for coliving: Coliving) -> Color {
        switch coliving.wifiRating {
        case .excellent: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        case .unknown: return .gray
        }
    }
}

struct MapPreviewCard: View {
    let coliving: Coliving
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coliving.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    Rectangle().fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "building.2").foregroundStyle(.secondary))
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coliving.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                
                Text("\(coliving.city), \(coliving.country)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(coliving.priceDisplay)
                    .font(.caption.weight(.medium))
                
                HStack(spacing: 4) {
                    WifiBadge(quality: coliving.wifiRating)
                    if let rating = coliving.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.caption2)
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}
