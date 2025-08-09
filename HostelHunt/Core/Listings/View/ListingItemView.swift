import SwiftUI

struct ListingItemView: View {
    @EnvironmentObject var authService: AuthService
    let listing: Listing
    
    var body: some View {
        VStack(spacing: 8) {
            // images
            ListingImageCarouselView(listing: listing)
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack(alignment: .top) {
                // details
                VStack(alignment: .leading) {
                    Text(listing.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                    Text("\(listing.city), \(listing.state)")
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 4) {
                        Text("₹\(listing.pricePerMonth)")
                            .fontWeight(.semibold)
                        Text("month")
                    }
                    .foregroundStyle(.black)
                }
                
                Spacer()
                
                // rating and wishlist
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        Text(formatRating(listing.rating))
                    }
                    .foregroundStyle(.black)
                    
                    if authService.user != nil {
                        Button {
                            Task {
                                if authService.isInWishlist(listing) {
                                    try await authService.removeFromWishlist(listing)
                                } else {
                                    try await authService.addToWishlist(listing)
                                }
                            }
                        } label: {
                            Image(systemName: authService.isInWishlist(listing) ? "heart.fill" : "heart")
                                .foregroundStyle(authService.isInWishlist(listing) ? .pink : .black)
                                .font(.caption)
                        }
                    }
                }
            }
            .font(.footnote)
        }
        .padding()
    }
}

#Preview {
    ListingItemView(listing: DeveloperPreview.shared.listings[0])
}
