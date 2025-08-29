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
                ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: ModernDesignSystem.Sizing.padding) {
                    VStack(spacing: ModernDesignSystem.Sizing.padding) {
                        TextField("Full Name", text: $fullname)
                            .modernTextField(isFocused: false)
                        TextField("Username", text: $username)
                            .modernTextField(isFocused: false)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        Task {
                            try await authService.updateUserProfile(fullname: fullname, username: username)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .modernButton()
                    }
                    
                    Spacer()
                }
                .padding(.top, ModernDesignSystem.Sizing.padding)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ModernDesignSystem.Colors.primary)
                }
            }
        }
    }
}
