import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var fullname: String
    @State private var username: String
    
    init(user: User) {
        _fullname = State(initialValue: user.fullname)
        _username = State(initialValue: user.username)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GenZDesignSystem.Colors.auroraBackground.ignoresSafeArea()
                
                VStack(spacing: GenZDesignSystem.Spacing.lg) {
                    VStack(spacing: GenZDesignSystem.Spacing.md) {
                        FuturisticTextField(placeholder: "Full Name", text: $fullname)
                        FuturisticTextField(placeholder: "Username", text: $username)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        Task {
                            try await authService.updateUserProfile(fullname: fullname, username: username)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(FuturisticPrimaryButton())
                    
                    Spacer()
                }
                .padding(.top, GenZDesignSystem.Spacing.lg)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(GenZDesignSystem.Colors.accent)
                }
            }
        }
    }
}
