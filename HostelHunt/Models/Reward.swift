import Foundation

struct Reward: Identifiable, Codable {
    let id: UUID
    let name: String
    let points: Int
}
