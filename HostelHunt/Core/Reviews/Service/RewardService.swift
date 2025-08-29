import Foundation
import Supabase

class RewardService {
    static let shared = RewardService()
    private let client = SupabaseManager.shared.client

    func fetchRewards() async throws -> [Reward] {
        let response: [Reward] = try await client.from("rewards")
            .select()
            .execute()
            .value
        return response
    }

    func fetchUserRewards(for userId: UUID) async throws -> [UserReward] {
        let response: [UserReward] = try await client.from("user_rewards")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        return response
    }

    func awardReward(_ reward: Reward, for userId: UUID) async throws {
        let userReward = UserReward(id: UUID(), userId: userId, rewardId: reward.id, createdAt: Date())
        try await client.from("user_rewards").insert(userReward).execute()
    }
}
