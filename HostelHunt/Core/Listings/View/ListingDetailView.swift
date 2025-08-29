import SwiftUI
import MapKit

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    let listing: Listing
    @State private var cameraPosition: MapCameraPosition
    @State private var showLogin = false
    @StateObject private var reservationService = ReservationService()
    @State private var isBooking = false
    @State private var bookingSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""

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
            ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ListingImageCarouselView(listing: listing)
                        .frame(height: 350)

                    VStack(alignment: .leading, spacing: ModernDesignSystem.Sizing.padding) {
                        ListingHeaderView(listing: listing)
                        ModernDetailSection(title: "Hosted by \(listing.ownerName)", icon: "person.crop.circle.fill") {
                            HostInfoView(listing: listing)
                        }
                        ModernDetailSection(title: "What this place offers", icon: "sparkles") {
                            AmenitiesView(amenities: listing.amenities)
                        }
                        ModernDetailSection(title: "Where you'll be", icon: "map.fill") {
                            MapView(listing: listing, cameraPosition: $cameraPosition)
                        }
                        Spacer()
                        .frame(height: 30)
                    }
                    .padding()
                    .background(ModernDesignSystem.Colors.solidBackground)
                    .clipShape(RoundedCorner(radius: ModernDesignSystem.Sizing.cornerRadius, corners: [.topLeft, .topRight]))
                    .offset(y: -ModernDesignSystem.Sizing.padding)
                }
            }
            .scrollClipDisabled()
            .ignoresSafeArea(.all, edges: .top)

            VStack {
                Spacer()
                ReserveBar(
                    listing: listing,
                    isBooking: $isBooking,
                    showLogin: $showLogin,
                    reserveAction: reserveListing
                )
            }

            HeaderActions(dismissAction: { dismiss() })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .alert("Success!", isPresented: $bookingSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your reservation for \(listing.title) has been confirmed.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private func reserveListing() {
        guard let user = authService.currentUser else {
            showLogin = true
            return
        }

        isBooking = true
        Task {
            do {
                try await reservationService.reserve(listing: listing, user: user)
                bookingSuccess = true
            } catch {
                errorMessage = "Failed to reserve the listing. Please try again."
                showError = true
            }
            isBooking = false
        }
    }
}

// MARK: - Subviews

private struct ListingHeaderView: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Sizing.padding) {
            Text(listing.title)
                .font(DesignSystem.Typography.titleLarge)
                .foregroundColor(ModernDesignSystem.Colors.text)

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("\(listing.city), \(listing.state)")
                Spacer()
                Image(systemName: "star.fill")
                Text(String(format: "%.1f", listing.rating))
            }
            .font(ModernDesignSystem.Typography.body)
            .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            .padding(.top, ModernDesignSystem.Sizing.padding)
        }
    }
}

private struct HostInfoView: View {
    let listing: Listing

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: ModernDesignSystem.Sizing.padding) {
                Text("Entire \(listing.type.description)")
                    .font(DesignSystem.Typography.headlineSmall)
                Text("\(listing.numberOfBeds) beds • \(listing.gender.description)")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            Spacer()
            Image(listing.ownerImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().stroke(ModernDesignSystem.Colors.heroGradient, lineWidth: 2))
        }
    }
}

private struct AmenitiesView: View {
    let amenities: [ListingAmenities]
    private let columns = [GridItem(.adaptive(minimum: 140), spacing: ModernDesignSystem.Sizing.padding)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: ModernDesignSystem.Sizing.padding) {
            ForEach(amenities) { amenity in
                HStack {
                    Image(systemName: amenity.imageName)
                        .font(.title3)
                        .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                        .frame(width: 30)
                    Text(amenity.title)
                        .font(ModernDesignSystem.Typography.body)
                    Spacer()
                }
                .padding(ModernDesignSystem.Sizing.padding)
                .background(ModernDesignSystem.Colors.cardBackground)
                .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
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
        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: ModernDesignSystem.Sizing.cornerRadius)
                .stroke(ModernDesignSystem.Colors.secondary.opacity(0.5), lineWidth: 1)
        )
    }
}

private struct ReserveBar: View {
    let listing: Listing
    @Binding var isBooking: Bool
    @Binding var showLogin: Bool
    var reserveAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("₹\(listing.pricePerMonth)")
                    .font(DesignSystem.Typography.titleLarge)
                Text("per month")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            Spacer()
            Button(action: reserveAction) {
                if isBooking {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Reserve")
                        .modernButton()
                }
            }
            .disabled(isBooking)
        }
        .padding(.horizontal, ModernDesignSystem.Sizing.padding)
        .padding(.vertical, ModernDesignSystem.Sizing.padding)
        .background(ModernDesignSystem.Colors.tabBarBackground)
        .clipShape(RoundedCorner(radius: ModernDesignSystem.Sizing.cornerRadius, corners: [.topLeft, .topRight]))
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
                        .padding(ModernDesignSystem.Sizing.padding)
                        .background(Circle().fill(ModernDesignSystem.Colors.cardBackground))
                        
                }
                Spacer()
                Button {
                    // TODO: Add to wishlist
                } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .padding(ModernDesignSystem.Sizing.padding)
                        .background(Circle().fill(ModernDesignSystem.Colors.cardBackground))
                        
                }
            }
            .font(DesignSystem.Typography.titleLarge)
            .foregroundColor(ModernDesignSystem.Colors.text)
            .padding(.horizontal, ModernDesignSystem.Sizing.padding)
            .padding(.top, 50)

            Spacer()
        }
        .ignoresSafeArea()
    }
}

private struct ModernDetailSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Sizing.padding) {
            HStack(spacing: ModernDesignSystem.Sizing.padding) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                Text(title)
                    .font(DesignSystem.Typography.titleLarge)
            }
            .foregroundColor(ModernDesignSystem.Colors.text)

            content
        }
        .padding()
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
    }

}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings[0])
        .environmentObject(AuthService())
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ListingDetailView(listing: DeveloperPreview.shared.listings[0])
}
