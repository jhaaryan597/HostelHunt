import SwiftUI

struct AnimatedSearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            
            TextField("Search...", text: $searchText)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
        }
        .padding()
        .background(GenZDesignSystem.Colors.glassPrimary)
        .cornerRadius(GenZDesignSystem.CornerRadius.lg)
    }
}
