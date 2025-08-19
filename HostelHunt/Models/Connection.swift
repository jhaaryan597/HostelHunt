import Foundation

struct Connection: Identifiable, Codable {
    let id: Int
    let createdAt: Date
    let userId1: UUID
    let userId2: UUID
    var status: String
}
