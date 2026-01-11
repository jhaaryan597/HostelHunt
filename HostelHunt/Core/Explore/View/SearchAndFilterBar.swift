import SwiftUI

struct SearchAndFilterBar: View {
    @ObservedObject var viewModel: ExploreViewModel
    @Binding var location: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)

            TextField("Search by city or location...", text: $location)
                .font(ModernDesignSystem.Typography.body)
                .focused($isTextFieldFocused)

            if !location.isEmpty {
                Button(action: {
                    location = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
            }
        }
        .padding()
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
        .padding(.horizontal)
    }
}

#Preview {
    SearchAndFilterBar(viewModel: ExploreViewModel(service: ExploreService()), location: .constant("Los Angeles"))
}
