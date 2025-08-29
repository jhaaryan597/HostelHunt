import SwiftUI

struct ReviewsView: View {
    let reviews: [AppReview]

    var body: some View {
        VStack(alignment: .leading) {
            if reviews.isEmpty {
                Text("No reviews yet.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            } else {
                ForEach(reviews) { review in
                    ReviewRowView(review: review)
                    Divider()
                }
            }
        }
    }
}

struct ReviewRowView: View {
    let review: AppReview

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // TODO: Fetch and display user's profile image
                VStack(alignment: .leading) {
                    // TODO: Fetch and display user's full name
                    Text("User \(review.userId.uuidString.prefix(8))")
                        .font(DesignSystem.Typography.headlineSmall)
                    Text(review.createdAt, style: .date)
                        .font(ModernDesignSystem.Typography.body)
                        .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                }
                Spacer()
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }

            if let reviewText = review.reviewText {
                Text(reviewText)
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}
