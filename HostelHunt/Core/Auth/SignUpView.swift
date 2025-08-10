import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var username = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: GenZDesignSystem.Spacing.lg) {
                    // Header
                    VStack {
                        Image(systemName: "sparkles.person.crop.circle.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(GenZDesignSystem.Colors.gradientPrimary)
                        
                        Text("Join the Hunt")
                            .font(GenZDesignSystem.Typography.displayMedium)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        
                        Text("Create your account to get started")
                            .font(GenZDesignSystem.Typography.body)
                            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    }
                    .padding(.vertical, GenZDesignSystem.Spacing.xl)

                    // Form
                    VStack(spacing: GenZDesignSystem.Spacing.md) {
                        GenZAuthTextField(iconName: "person.text.rectangle.fill", placeholder: "Full Name", text: $fullName)
                        GenZAuthTextField(iconName: "at.circle.fill", placeholder: "Username", text: $username)
                        GenZAuthTextField(iconName: "envelope.fill", placeholder: "Email", text: $email)
                        GenZAuthTextField(iconName: "lock.shield.fill", placeholder: "Password", text: $password, isSecure: true)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(GenZDesignSystem.Colors.error)
                            .font(GenZDesignSystem.Typography.caption)
                            .padding(.top, GenZDesignSystem.Spacing.sm)
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
                            .primaryButton()
                    }
                    .padding(.top, GenZDesignSystem.Spacing.md)

                    Spacer()

                    // Sign In Link
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: GenZDesignSystem.Spacing.xs) {
                            Text("Already have an account?")
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundStyle(GenZDesignSystem.Colors.gradientPrimary)
                        }
                        .font(GenZDesignSystem.Typography.body)
                    }
                    .padding(.bottom, GenZDesignSystem.Spacing.md)
                }
                .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            }
            .navigationBarHidden(true)
        }
    }
}
