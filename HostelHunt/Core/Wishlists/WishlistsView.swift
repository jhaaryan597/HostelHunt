import SwiftUI

struct WishlistsView: View {
    @StateObject var viewModel: WishlistsViewModel
    @EnvironmentObject var authService: AuthService
    @State private var showLogin = false
    
    init() {
        self._viewModel = StateObject(wrappedValue: WishlistsViewModel(service: ExploreService()))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()

                if authService.user != nil {
                    VStack {
                        if viewModel.isLoading {
                            // Loading state
                            VStack(spacing: ModernDesignSystem.Sizing.padding) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Text("Loading your wishlist...")
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                            }
                        } else if let errorMessage = viewModel.errorMessage {
                            // Error state
                            VStack(spacing: ModernDesignSystem.Sizing.padding) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 48))
                                    .foregroundColor(.red)

                                Text(errorMessage)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)

                                Button("Try Again") {
                                    Task { await viewModel.fetchWishlist() }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        } else if viewModel.listings.isEmpty {
                            // Empty state
                            VStack(spacing: ModernDesignSystem.Sizing.padding) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 64))
                                    .foregroundStyle(ModernDesignSystem.Colors.heroGradient)

                                Text("Your Wishlist Awaits!")
                                    .font(DesignSystem.Typography.titleLarge)
                                    .foregroundColor(ModernDesignSystem.Colors.text)

                                Text("Tap the heart on any listing to save it here.")
                                    .font(ModernDesignSystem.Typography.body)
                                    .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        } else {
                            // Listings
                            ScrollView {
                                ForEach(viewModel.listings) { listing in
                                    ListingItemView(listing: listing)
                                        .environmentObject(authService)
                                        .padding(.horizontal, ModernDesignSystem.Sizing.padding)
                                        .padding(.vertical, ModernDesignSystem.Sizing.padding)
                                }
                            }
                        }
                    }
                    .navigationTitle("Wishlists")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        Task {
                            await viewModel.fetchWishlist()
                        }
                    }
                } else {
                    VStack(spacing: ModernDesignSystem.Sizing.padding) {
                        Spacer()
                        
                        Image(systemName: "lock.heart.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(ModernDesignSystem.Colors.heroGradient)
                            
                        
                        VStack(spacing: ModernDesignSystem.Sizing.padding) {
                            Text("Unlock Your Wishlists")
                                .font(DesignSystem.Typography.titleLarge)
                                .foregroundColor(ModernDesignSystem.Colors.text)
                            
                            Text("Log in to create, view, and edit your wishlists.")
                                .font(ModernDesignSystem.Typography.body)
                                .foregroundColor(ModernDesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            showLogin.toggle()
                        } label: {
                            Text("Log In & Explore")
                                .modernButton()
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

#Preview {
    WishlistsView()
}
