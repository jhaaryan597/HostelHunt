import Foundation

struct UserReward: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let rewardId: UUID
    let createdAt: Date
}
