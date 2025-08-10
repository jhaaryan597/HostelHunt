import SwiftUI
import MapKit

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    let listing: Listing
    @State private var cameraPosition: MapCameraPosition
    @State private var showLogin = false

    init(listing: Listing) {
        self.listing = listing
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: listing.latitude, longitude: listing.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        self._cameraPosition = State(initialValue: .region(region))
    }

    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ListingImageCarouselView(listing: listing)
                        .frame(height: 350)

                    VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
                        ListingHeaderView(listing: listing)
                        GenZDetailSection(title: "Hosted by \(listing.ownerName)", icon: "person.crop.circle.fill") {
                            HostInfoView(listing: listing)
                        }
                        GenZDetailSection(title: "What this place offers", icon: "sparkles") {
                            AmenitiesView(amenities: listing.amenities)
                        }
                        GenZDetailSection(title: "Where you'll be", icon: "map.fill") {
                            MapView(listing: listing, cameraPosition: $cameraPosition)
                        }
                    }
                    .padding()
                    .background(GenZDesignSystem.Colors.background)
                    .cornerRadius(GenZDesignSystem.CornerRadius.xl, corners: [.topLeft, .topRight])
                    .offset(y: -GenZDesignSystem.Spacing.xl)
                }
            }
            .scrollClipDisabled()
            .ignoresSafeArea(edges: .top)

            VStack {
                Spacer()
                ReserveBar(listing: listing, showLogin: $showLogin)
            }

            HeaderActions(dismissAction: { dismiss() })
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
    }
}

// MARK: - Subviews

private struct ListingHeaderView: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
            Text(listing.title)
                .font(GenZDesignSystem.Typography.displaySmall)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("\(listing.city), \(listing.state)")
                Spacer()
                Image(systemName: "star.fill")
                Text(String(format: "%.1f", listing.rating))
            }
            .font(GenZDesignSystem.Typography.bodySmall)
            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            .padding(.top, GenZDesignSystem.Spacing.xs)
        }
    }
}

private struct HostInfoView: View {
    let listing: Listing

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.sm) {
                Text("Entire \(listing.type.description)")
                    .font(GenZDesignSystem.Typography.title2)
                Text("\(listing.numberOfBeds) beds • \(listing.gender.description)")
                    .font(GenZDesignSystem.Typography.bodySmall)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            }
            Spacer()
            Image(listing.ownerImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().stroke(GenZDesignSystem.Colors.gradientPrimary, lineWidth: 2))
        }
    }
}

private struct AmenitiesView: View {
    let amenities: [ListingAmenities]
    private let columns = [GridItem(.adaptive(minimum: 140), spacing: GenZDesignSystem.Spacing.md)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: GenZDesignSystem.Spacing.md) {
            ForEach(amenities) { amenity in
                HStack {
                    Image(systemName: amenity.imageName)
                        .font(.title3)
                        .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                        .frame(width: 30)
                    Text(amenity.title)
                        .font(GenZDesignSystem.Typography.bodySmall)
                    Spacer()
                }
                .padding(GenZDesignSystem.Spacing.md)
                .background(GenZDesignSystem.Colors.glassPrimary)
                .cornerRadius(GenZDesignSystem.CornerRadius.lg)
            }
        }
    }
}

private struct MapView: View {
    let listing: Listing
    @Binding var cameraPosition: MapCameraPosition

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(listing.title, coordinate: CLLocationCoordinate2D(latitude: listing.latitude, longitude: listing.longitude))
        }
        .frame(height: 200)
        .cornerRadius(GenZDesignSystem.CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct ReserveBar: View {
    let listing: Listing
    @Binding var showLogin: Bool
    @EnvironmentObject var authService: AuthService

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.xs) {
                Text("₹\(listing.pricePerMonth)")
                    .font(GenZDesignSystem.Typography.price)
                Text("per month")
                    .font(GenZDesignSystem.Typography.bodySmall)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            }
            Spacer()
            Button {
                if authService.user == nil {
                    showLogin = true
                }
            } label: {
                Text("Reserve")
                    .primaryButton()
            }
        }
        .padding(GenZDesignSystem.Spacing.lg)
        .background(.ultraThinMaterial)
        .cornerRadius(GenZDesignSystem.CornerRadius.xl, corners: [.topLeft, .topRight])
        .overlay(alignment: .top) {
            Rectangle()
                .fill(GenZDesignSystem.Colors.gradientPrimary.opacity(0.5))
                .frame(height: 1)
        }
    }
}

private struct HeaderActions: View {
    var dismissAction: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(GenZDesignSystem.Spacing.sm)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        
                }
                Spacer()
                Button {
                    // TODO: Add to wishlist
                } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .padding(GenZDesignSystem.Spacing.sm)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        
                }
            }
            .font(GenZDesignSystem.Typography.title2)
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.top, 50)

            Spacer()
        }
        .ignoresSafeArea()
    }
}

private struct GenZDetailSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                Text(title)
                    .font(GenZDesignSystem.Typography.title2)
            }
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)

            content
        }
        .padding()
        .background(GenZDesignSystem.Colors.glassPrimary)
        .cornerRadius(GenZDesignSystem.CornerRadius.xl)
    }
}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings[0])
        .environmentObject(AuthService())
}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings[0])
}
