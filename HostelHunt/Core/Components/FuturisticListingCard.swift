import SwiftUI

struct FuturisticListingCard: View {
    let listing: Listing
    
    var body: some View {
        FuturisticCard {
            VStack {
                ListingImageCarouselView(listing: listing)
                    .frame(height: 200)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(listing.title)
                            .font(GenZDesignSystem.Typography.title3)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        
                        Text("\(listing.city), \(listing.state)")
                            .font(GenZDesignSystem.Typography.body)
                            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("₹\(listing.pricePerMonth)")
                            .font(GenZDesignSystem.Typography.title3)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        
                        Text("per month")
                            .font(GenZDesignSystem.Typography.caption)
                            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    }
                }
                .padding()
            }
        }
    }
}
