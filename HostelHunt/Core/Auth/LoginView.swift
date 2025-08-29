import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authService: AuthService
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool

    var body: some View {
        ZStack {
            ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: ModernDesignSystem.Sizing.padding) {
                    // Header
                    VStack {
                        Image("HostelHunt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            
                        
                        Text("Welcome Back")
                            .font(DesignSystem.Typography.displayMedium)
                            .foregroundColor(ModernDesignSystem.Colors.text)
                        
                        Text("Log in to continue your adventure")
                            .font(ModernDesignSystem.Typography.body)
                            .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                    }
                    .padding(.vertical, ModernDesignSystem.Sizing.padding)

                    // Form
                    VStack(spacing: ModernDesignSystem.Sizing.padding) {
                        TextField("Email", text: $email)
                            .modernTextField(isFocused: isEmailFocused)
                            .focused($isEmailFocused)
                        
                        SecureField("Password", text: $password)
                            .modernTextField(isFocused: isPasswordFocused)
                            .focused($isPasswordFocused)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(ModernDesignSystem.Colors.primary)
                            .font(ModernDesignSystem.Typography.body)
                            .padding(.top, ModernDesignSystem.Sizing.padding)
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
                            .modernButton()
                    }
                    .padding(.top, ModernDesignSystem.Sizing.padding)

                    Spacer()

                    // Sign Up Link
                    NavigationLink(destination: SignUpView()) {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            Text("Sign Up")
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
