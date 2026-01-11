import Foundation

@MainActor
class WishlistsViewModel: ObservableObject {
    @Published var listings = [Listing]()
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: ExploreService
    private var authService: AuthService {
        return AuthService.shared
    }

    init(service: ExploreService) {
        self.service = service

        Task {
            await fetchWishlist()
        }
    }

    func fetchWishlist() async {
        guard let user = authService.currentUser else {
            self.listings = []
            return
        }

        guard let wishlist = user.wishlist, !wishlist.isEmpty else {
            self.listings = []
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            self.listings = try await service.fetchListings(withIDs: wishlist)
        } catch {
            errorMessage = "Failed to load wishlist. Please try again."
            print("DEBUG: Failed to fetch wishlist with error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
