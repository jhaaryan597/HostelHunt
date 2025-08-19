import SwiftUI

struct UserProfileView: View {
    let user: User
    
    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.auroraBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: GenZDesignSystem.Spacing.lg) {
                    // Profile Header
                    FuturisticCard {
                        VStack {
                            Image(user.profileImageUrl ?? "default-profile-image")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(GenZDesignSystem.Colors.primary, lineWidth: 2)
                                )
                            
                            Text(user.fullname)
                                .font(GenZDesignSystem.Typography.title2)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                                .padding(.top, GenZDesignSystem.Spacing.sm)
                            
                            Text("@\(user.username)")
                                .font(GenZDesignSystem.Typography.body)
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Bio Section
                    FuturisticCard {
                        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.sm) {
                            Text("About Me")
                                .font(GenZDesignSystem.Typography.title3)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                                .font(GenZDesignSystem.Typography.body)
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Interests Section
                    FuturisticCard {
                        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.sm) {
                            Text("Interests")
                                .font(GenZDesignSystem.Typography.title3)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            
                            HStack {
                                ForEach(["Hiking", "Photography", "Foodie"], id: \.self) { interest in
                                    Text(interest)
                                        .font(GenZDesignSystem.Typography.caption)
                                        .padding(.horizontal, GenZDesignSystem.Spacing.md)
                                        .padding(.vertical, GenZDesignSystem.Spacing.sm)
                                        .background(GenZDesignSystem.Colors.primary.opacity(0.2))
                                        .foregroundColor(GenZDesignSystem.Colors.primary)
                                        .cornerRadius(GenZDesignSystem.CornerRadius.sm)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
