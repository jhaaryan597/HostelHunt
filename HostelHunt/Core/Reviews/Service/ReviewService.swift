import Foundation
import Supabase

class ReviewService {
    static let shared = ReviewService()
    private let client = SupabaseManager.shared.client

    func fetchReviews(for listingId: UUID) async throws -> [AppReview] {
        let response: [AppReview] = try await client.from("reviews")
            .select()
            .eq("listing_id", value: listingId)
            .execute()
            .value
        return response
    }

    func postReview(_ review: AppReview) async throws {
        try await client.from("reviews").insert(review).execute()
    }
}
