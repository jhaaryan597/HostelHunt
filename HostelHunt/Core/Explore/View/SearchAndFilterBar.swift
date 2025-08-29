import SwiftUI

struct SearchAndFilterBar: View {
    @ObservedObject var viewModel: ExploreViewModel
    @Binding var location: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            TextField("Where to?", text: $location)
                .font(ModernDesignSystem.Typography.body)
                .modernTextField(isFocused: isTextFieldFocused)
                .focused($isTextFieldFocused)

            Button(action: {
                viewModel.updateListingsForLocation()
            }) {
                Text("Search")
                    .modernButton()
            }
        }
        .padding()
    }
}

#Preview {
    SearchAndFilterBar(viewModel: ExploreViewModel(service: ExploreService()), location: .constant("Los Angeles"))
}
