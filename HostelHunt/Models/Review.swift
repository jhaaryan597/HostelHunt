import Foundation

struct AppReview: Codable, Identifiable {
    let id: UUID
    let listingId: UUID
    let userId: UUID
    let rating: Int
    let reviewText: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case listingId = "listing_id"
        case userId = "user_id"
        case rating
        case reviewText = "review_text"
        case createdAt = "created_at"
    }
}
