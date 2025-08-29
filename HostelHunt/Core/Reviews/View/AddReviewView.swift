import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var authService = AuthService.shared
    let listing: Listing
    let onReviewSubmitted: () -> Void

    @State private var rating = 0
    @State private var reviewText = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Your Rating")) {
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .foregroundColor(ModernDesignSystem.Colors.accent1)
                                    .onTapGesture {
                                        rating = index
                                    }
                            }
                        }
                    }

                    Section(header: Text("Your Review")) {
                        TextEditor(text: $reviewText)
                            .frame(height: 100)
                    }
                }
            }
            .background(ModernDesignSystem.Colors.solidBackground)
            .navigationTitle("Add Review")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() }.foregroundColor(ModernDesignSystem.Colors.primary),
                trailing: Button("Submit") { submitReview() }
                    .disabled(isSubmitting || rating == 0)
                    .foregroundColor(ModernDesignSystem.Colors.primary)
            )
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func submitReview() {
        guard let user = authService.currentUser, 
              let userId = UUID(uuidString: user.id),
              let listingId = UUID(uuidString: listing.id) else {
            errorMessage = "Invalid user or listing ID"
            showError = true
            return
        }

        isSubmitting = true
        let review = AppReview(
            id: UUID(),
            listingId: listingId, // Now using the converted UUID
            userId: userId,
            rating: rating,
            reviewText: reviewText,
            createdAt: Date()
        )

        Task {
            do {
                try await ReviewService.shared.postReview(review)
                onReviewSubmitted()
                dismiss()
            } catch {
                errorMessage = "Failed to submit review. Please try again."
                showError = true
            }
            isSubmitting = false
        }
    }
}
