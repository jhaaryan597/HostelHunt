import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                GenZDesignSystem.Colors.background.ignoresSafeArea()

                if let user = authService.currentUser {
                    // Logged-in view
                    ScrollView {
                        VStack(spacing: GenZDesignSystem.Spacing.lg) {
                            // Profile Header
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(GenZDesignSystem.Colors.primary, lineWidth: 2)
                                    )
                                    
                                    .padding(.top, GenZDesignSystem.Spacing.lg)

                                Text(user.fullname)
                                    .font(GenZDesignSystem.Typography.title2)
                                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                                    .padding(.top, GenZDesignSystem.Spacing.sm)

                                Text("@\(user.username)")
                                    .font(GenZDesignSystem.Typography.body)
                                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                            }

                            // Profile Details Section
                            VStack(spacing: GenZDesignSystem.Spacing.md) {
                                GenZProfileDetailRow(iconName: "envelope.fill", label: "Email", value: user.email)
                                GenZProfileDetailRow(iconName: "calendar", label: "Joined", value: "June 2024") // Placeholder
                            }
                            .padding(.horizontal)

                            Spacer()

                            // Sign Out Button
                            Button {
                                Task {
                                    try await authService.signOut()
                                }
                            } label: {
                                Text("Sign Out")
                                    .accentButton()
                            }
                            .padding(.bottom, GenZDesignSystem.Spacing.lg)

                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Profile")
                                .font(GenZDesignSystem.Typography.title3)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        }
                    }
                } else {
                    // Logged-out view
                    VStack(spacing: GenZDesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 80))
                            .foregroundColor(GenZDesignSystem.Colors.accent)
                            
                        
                        VStack(spacing: GenZDesignSystem.Spacing.sm) {
                            Text("Join the Community")
                                .font(GenZDesignSystem.Typography.title2)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            
                            Text("Log in to manage your profile and connect with others.")
                                .font(GenZDesignSystem.Typography.body)
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            showLogin.toggle()
                        } label: {
                            Text("Log In / Sign Up")
                                .primaryButton()
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    .sheet(isPresented: $showLogin) {
                        LoginView()
                            .environmentObject(authService)
                    }
                }
            }
        }
    }
}

struct GenZProfileDetailRow: View {
    let iconName: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                .frame(width: 40)
            
            Text(label)
                .font(GenZDesignSystem.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(GenZDesignSystem.Typography.body)
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(GenZDesignSystem.CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
