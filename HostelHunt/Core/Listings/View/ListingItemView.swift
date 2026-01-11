import SwiftUI

struct ListingItemView: View {
    @EnvironmentObject var authService: AuthService
    let listing: Listing
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 8) {
            // images
            ListingImageCarouselView(listing: listing)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: ModernDesignSystem.Sizing.cornerRadius))

            HStack(alignment: .top) {
                // details
                VStack(alignment: .leading) {
                    Text(listing.title)
                        .fontWeight(.semibold)
                        .foregroundColor(ModernDesignSystem.Colors.text)

                    Text("\(listing.city), \(listing.state)")
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                    HStack(spacing: 4) {
                        Text("₹\(listing.pricePerMonth)")
                            .fontWeight(.semibold)
                        Text("month")
                    }
                    .foregroundColor(ModernDesignSystem.Colors.text)
                }

                Spacer()

                // rating and wishlist
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        Text(formatRating(listing.rating))
                    }
                    .foregroundColor(ModernDesignSystem.Colors.text)

                    if authService.user != nil {
                        Button {
                            Task {
                                do {
                                    if authService.isInWishlist(listing) {
                                        try await authService.removeFromWishlist(listing)
                                    } else {
                                        try await authService.addToWishlist(listing)
                                    }
                                } catch {
                                    errorMessage = "Failed to update wishlist. Please try again."
                                    showErrorAlert = true
                                }
                            }
                        } label: {
                            Image(systemName: authService.isInWishlist(listing) ? "heart.fill" : "heart")
                                .foregroundStyle(authService.isInWishlist(listing) ? ModernDesignSystem.Colors.accent1 : ModernDesignSystem.Colors.text)
                                .font(.caption)
                        }
                    }
                }
            }
            .font(ModernDesignSystem.Typography.body)
        }
        .modernCard()
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    ListingItemView(listing: DeveloperPreview.shared.listings[0])
}
