import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showLogin = false
    @State private var showEditProfile = false

    var body: some View {
        NavigationStack {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()

                if let user = authService.currentUser {
                    // Logged-in view
                    ScrollView {
                        VStack(spacing: ModernDesignSystem.Sizing.padding) {
                            // Profile Header
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                                    .padding()
                                    .background(ModernDesignSystem.Colors.cardBackground)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(ModernDesignSystem.Colors.primary, lineWidth: 2)
                                    )
                                
                                Text(user.fullname)
                                    .font(DesignSystem.Typography.titleLarge)
                                    .foregroundColor(ModernDesignSystem.Colors.text)
                                    .padding(.top, ModernDesignSystem.Sizing.padding)

                                Text("@\(user.username)")
                                    .font(ModernDesignSystem.Typography.body)
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            }
                            .modernCard()
                            .padding(.horizontal)

                            // Profile Details Section
                            VStack(spacing: ModernDesignSystem.Sizing.padding) {
                                ModernProfileDetailRow(iconName: "envelope.fill", label: "Email", value: user.email)
                                ModernProfileDetailRow(iconName: "calendar", label: "Joined", value: "June 2024") // Placeholder
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
                                    .modernButton()
                            }
                            .padding(.bottom, ModernDesignSystem.Sizing.padding)

                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showEditProfile.toggle()
                            } label: {
                                Text("Edit")
                                    .font(ModernDesignSystem.Typography.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(ModernDesignSystem.Colors.primary)
                            }
                        }
                    }
                    .sheet(isPresented: $showEditProfile) {
                        if let user = authService.currentUser {
                            EditProfileView(user: user)
                                .environmentObject(authService)
                        }
                    }
                } else {
                    // Logged-out view
                    VStack(spacing: ModernDesignSystem.Sizing.padding) {
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 80))
                            .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                            
                        
                        VStack(spacing: ModernDesignSystem.Sizing.padding) {
                            Text("Join the Community")
                                .font(DesignSystem.Typography.titleLarge)
                                .foregroundColor(ModernDesignSystem.Colors.text)
                            
                            Text("Log in to manage your profile and connect with others.")
                                .font(ModernDesignSystem.Typography.body)
                                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            showLogin.toggle()
                        } label: {
                            Text("Log In / Sign Up")
                                .modernButton()
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            LoginView()
                                .environmentObject(authService)
                        }
                    }
                }
            }
        }
    }
}

struct ModernProfileDetailRow: View {
    let iconName: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                .frame(width: 40)
            
            Text(label)
                .font(ModernDesignSystem.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.text)
            
            Spacer()
            
            Text(value)
                .font(ModernDesignSystem.Typography.body)
                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(ModernDesignSystem.Colors.cardBackground)
        .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
        .shadow(color: ModernDesignSystem.Colors.primary.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
