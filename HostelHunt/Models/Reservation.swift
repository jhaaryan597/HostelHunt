import Foundation

struct Reservation: Codable, Identifiable {
    let id: String
    let listingId: String
    let userId: String
    let startDate: Date
    let endDate: Date
    let totalPrice: Int

    enum CodingKeys: String, CodingKey {
        case id
        case listingId = "listing_id"
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalPrice = "total_price"
    }
}
