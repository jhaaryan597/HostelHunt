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
                GenZDesignSystem.Colors.background.ignoresSafeArea()

                if authService.user != nil {
                    VStack {
                        if viewModel.listings.isEmpty {
                            VStack(spacing: GenZDesignSystem.Spacing.md) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 64))
                                    .foregroundColor(GenZDesignSystem.Colors.accent)
                                    
                                
                                Text("Your Wishlist Awaits!")
                                    .font(GenZDesignSystem.Typography.title2)
                                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                                
                                Text("Tap the heart on any listing to save it here.")
                                    .font(GenZDesignSystem.Typography.body)
                                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        } else {
                            ScrollView {
                                ForEach(viewModel.listings) { listing in
                                    ListingItemView(listing: listing)
                                        .environmentObject(authService)
                                        .padding(.horizontal, GenZDesignSystem.Spacing.md)
                                        .padding(.vertical, GenZDesignSystem.Spacing.sm)
                                }
                            }
                        }
                    }
                    .navigationTitle("Wishlists")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Wishlists")
                                .font(GenZDesignSystem.Typography.title3)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        }
                    }
                    .onAppear {
                        Task {
                            await viewModel.fetchWishlist()
                        }
                    }
                } else {
                    VStack(spacing: GenZDesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "lock.heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(GenZDesignSystem.Colors.accent)
                            
                        
                        VStack(spacing: GenZDesignSystem.Spacing.sm) {
                            Text("Unlock Your Wishlists")
                                .font(GenZDesignSystem.Typography.title2)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            
                            Text("Log in to create, view, and edit your wishlists.")
                                .font(GenZDesignSystem.Typography.body)
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Button {
                            showLogin.toggle()
                        } label: {
                            Text("Log In & Explore")
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

#Preview {
    WishlistsView()
}
