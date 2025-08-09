import Foundation

@MainActor
class WishlistsViewModel: ObservableObject {
    @Published var listings = [Listing]()
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
        guard let user = authService.currentUser, let wishlist = user.wishlist else { return }
        
        do {
            self.listings = try await service.fetchListings(withIDs: wishlist)
        } catch {
            print("DEBUG: Failed to fetch wishlist with error: \(error.localizedDescription)")
        }
    }
}
