import SwiftUI

struct CommunityView: View {
    @State private var users: [User] = [
        User(id: "1", fullname: "Jessica Parker", email: "jessica@test.com", username: "jessica", profileImageUrl: "female-profile-photo1"),
        User(id: "2", fullname: "John Smith", email: "john@test.com", username: "john", profileImageUrl: "male-profile-photo1"),
        User(id: "3", fullname: "Emily Jones", email: "emily@test.com", username: "emily", profileImageUrl: "female-profile-photo2"),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GenZDesignSystem.Colors.auroraBackground.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: GenZDesignSystem.Spacing.md) {
                        ForEach(users) { user in
                            NavigationLink(destination: UserProfileView(user: user)) {
                                FuturisticCard {
                                    UserRowView(user: user)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: GenZDesignSystem.Spacing.md) {
            Image(user.profileImageUrl ?? "default-profile-image")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.fullname)
                    .font(GenZDesignSystem.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("@\(user.username)")
                    .font(GenZDesignSystem.Typography.caption)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Button {
                Task {
                    try await AuthService.shared.sendConnectionRequest(to: user)
                }
            } label: {
                Text("Connect")
            }
            .buttonStyle(FuturisticPrimaryButton())
        }
    }
}
