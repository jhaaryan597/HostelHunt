import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.auroraBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: GenZDesignSystem.Spacing.lg) {
                    // Header
                    VStack {
                        Image(systemName: "building.2.crop.circle.fill") // Or a custom logo
                            .font(.system(size: 100))
                            .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                            
                        
                        Text("Welcome Back")
                            .font(GenZDesignSystem.Typography.displayMedium)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        
                        Text("Log in to continue your adventure")
                            .font(GenZDesignSystem.Typography.bodySmall)
                            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    }
                    .padding(.vertical, GenZDesignSystem.Spacing.xl)

                    // Form
                    VStack(spacing: GenZDesignSystem.Spacing.md) {
                        FuturisticTextField(placeholder: "Email", text: $email)
                        FuturisticTextField(placeholder: "Password", text: $password)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(GenZDesignSystem.Colors.error)
                            .font(GenZDesignSystem.Typography.caption)
                            .padding(.top, GenZDesignSystem.Spacing.sm)
                    }

                    // Login Button
                    Button {
                        Task {
                            do {
                                try await authService.signIn(withEmail: email, password: password)
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Log In")
                    }
                    .buttonStyle(FuturisticPrimaryButton())
                    .padding(.top, GenZDesignSystem.Spacing.md)

                    Spacer()

                    // Sign Up Link
                    NavigationLink(destination: SignUpView()) {
                        HStack(spacing: GenZDesignSystem.Spacing.xs) {
                            Text("Don't have an account?")
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundStyle(GenZDesignSystem.Colors.gradientPrimary)
                        }
                        .font(GenZDesignSystem.Typography.bodyRegular)
                    }
                    .padding(.bottom, GenZDesignSystem.Spacing.md)
                }
                .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            }
            .navigationBarHidden(true)
        }
    }
}
