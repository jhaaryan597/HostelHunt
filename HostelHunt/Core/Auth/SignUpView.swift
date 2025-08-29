import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var username = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isFullNameFocused: Bool
    @FocusState private var isUsernameFocused: Bool

    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: ModernDesignSystem.Sizing.padding) {
                    // Header
                    VStack {
                        Image(systemName: "sparkles.person.crop.circle.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                        
                        Text("Join the Hunt")
                            .font(DesignSystem.Typography.displayMedium)
                            .foregroundColor(ModernDesignSystem.Colors.text)
                        
                        Text("Create your account to get started")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    }
                    .padding(.vertical, ModernDesignSystem.Sizing.padding)

                    // Form
                    VStack(spacing: ModernDesignSystem.Sizing.padding) {
                        TextField("Full Name", text: $fullName)
                            .modernTextField(isFocused: isFullNameFocused)
                            .focused($isFullNameFocused)
                        
                        TextField("Username", text: $username)
                            .modernTextField(isFocused: isUsernameFocused)
                            .focused($isUsernameFocused)
                        
                        TextField("Email", text: $email)
                            .modernTextField(isFocused: isEmailFocused)
                            .focused($isEmailFocused)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .modernTextField(isFocused: isPasswordFocused)
                            .focused($isPasswordFocused)
                            .autocapitalization(.none)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(ModernDesignSystem.Colors.primary)
                            .font(ModernDesignSystem.Typography.body)
                            .padding(.top, ModernDesignSystem.Sizing.padding)
                    }

                    // Sign Up Button
                    Button {
                        Task {
                            do {
                                try await authService.signUp(withEmail: email, password: password, fullName: fullName, username: username)
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Create Account")
                            .modernButton()
                    }
                    .padding(.top, ModernDesignSystem.Sizing.padding)

                    Spacer()

                    // Sign In Link
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                        }
                        .font(ModernDesignSystem.Typography.body)
                    }
                    .padding(.bottom, ModernDesignSystem.Sizing.padding)
                }
                .padding(.horizontal, ModernDesignSystem.Sizing.padding)
            }
            .navigationBarHidden(true)
        }
    }
}
