import SwiftUI

struct RewardsView: View {
    @State private var rewards: [Reward] = []
    @State private var userRewards: [UserReward] = []
    @State private var totalPoints = 0

    var body: some View {
        VStack(alignment: .leading, spacing: ModernDesignSystem.Sizing.padding) {
            HStack {
                Text("Rewards")
                    .font(DesignSystem.Typography.titleLarge)
                Spacer()
                Text("\(totalPoints) Points")
                    .font(DesignSystem.Typography.titleLarge)
                    .foregroundColor(ModernDesignSystem.Colors.primary)
            }

            if userRewards.isEmpty {
                Text("No rewards yet.")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            } else {
                ForEach(userRewards) { userReward in
                    if let reward = rewards.first(where: { $0.id == userReward.rewardId }) {
                        HStack {
                            Text(reward.name)
                                .font(ModernDesignSystem.Typography.body)
                            Spacer()
                            Text("+\(reward.points) Points")
                                .font(ModernDesignSystem.Typography.body)
                                .foregroundColor(ModernDesignSystem.Colors.primary)
                        }
                        .padding()
                        .background(ModernDesignSystem.Colors.cardBackground)
                        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
                    }
                }
            }

            HStack {
                Spacer()
                Button("Refer a Friend") {
                    // TODO: Implement refer a friend functionality
                }
                .modernButton()
                Spacer()
            }
        }
        .padding()
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
        .onAppear {
            fetchRewards()
        }
    }

    private func fetchRewards() {
        Task {
            do {
                let fetchedRewards = try await RewardService.shared.fetchRewards()
                self.rewards = fetchedRewards
                
                if let userId = AuthService.shared.currentUser?.id, let userUUID = UUID(uuidString: userId) {
                    let fetchedUserRewards = try await RewardService.shared.fetchUserRewards(for: userUUID)
                    self.userRewards = fetchedUserRewards
                    
                    totalPoints = fetchedUserRewards.reduce(0) { total, userReward in
                        if let reward = fetchedRewards.first(where: { $0.id == userReward.rewardId }) {
                            return total + reward.points
                        }
                        return total
                    }
                }
            } catch {
                print("Error fetching rewards: \(error.localizedDescription)")
            }
        }
    }
}
