import SwiftUI

struct CommunityView: View {
    @State private var users: [User] = [
        User(id: "1", fullname: "Jessica Parker", email: "jessica@test.com", username: "jessica", profileImageUrl: "female-profile-photo1", wishlist: nil, deviceToken: nil, phoneNumber: nil),
        User(id: "2", fullname: "John Smith", email: "john@test.com", username: "john", profileImageUrl: "male-profile-photo1", wishlist: nil, deviceToken: nil, phoneNumber: nil),
        User(id: "3", fullname: "Emily Jones", email: "emily@test.com", username: "emily", profileImageUrl: "female-profile-photo2", wishlist: nil, deviceToken: nil, phoneNumber: nil),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: ModernDesignSystem.Sizing.padding) {
                        ForEach(users) { user in
                            NavigationLink(destination: UserProfileView(user: user)) {
                                UserRowView(user: user)
                                    .modernCard()
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
        HStack(spacing: ModernDesignSystem.Sizing.padding) {
            Image(user.profileImageUrl ?? "default-profile-image")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.fullname)
                    .font(ModernDesignSystem.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(ModernDesignSystem.Colors.text)
                
                Text("@\(user.username)")
                    .font(ModernDesignSystem.Typography.body)
                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
        }
    }
}
