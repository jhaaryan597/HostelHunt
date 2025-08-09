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
            if authService.user != nil {
                VStack {
                    if viewModel.listings.isEmpty {
                        Text("Your wishlist is empty.")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    } else {
                        ScrollView {
                            ForEach(viewModel.listings) { listing in
                                ListingItemView(listing: listing)
                                    .environmentObject(authService)
                                    .onTapGesture {
                                        // Navigate to listing detail view
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Wishlists")
                .onAppear {
                    Task {
                        await viewModel.fetchWishlist()
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Log in to view your wishlists")
                            .font(.headline)
                        
                        Text("You can create, view or edit wishlists once you've logged in")
                            .font(.footnote)
                    }
                    
                    Button {
                        showLogin.toggle()
                    } label: {
                        Text("Log in")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 48)
                            .background(Color("AccentColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Wishlists")
                .sheet(isPresented: $showLogin) {
                    NavigationView {
                        LoginView()
                    }
                }
            }
        }
    }
}

#Preview {
    WishlistsView()
}
