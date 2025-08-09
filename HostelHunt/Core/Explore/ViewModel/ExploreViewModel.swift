import Foundation
import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var listings = [Listing]()
    @Published var searchLocation = ""
    @Published var selectedGender: Gender?
    @Published var sortOrder: SortOrder = .none
    
    private let service: ExploreService
    private let authService: AuthService
    private var listingsCopy = [Listing]()
    private var currentPage = 0
    private let listingsPerPage = 10
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    init(service: ExploreService, authService: AuthService = .shared) {
        self.service = service
        self.authService = authService
        
        authService.$user
            .sink { [weak self] user in
                Task {
                    if user != nil {
                        await self?.fetchListings()
                    } else {
                        self?.listings = []
                        self?.listingsCopy = []
                        self?.currentPage = 0
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchListings() async {
        guard authService.user != nil else { return }
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let new_listings = try await service.fetchListings(page: currentPage, limit: listingsPerPage)
            self.listings.append(contentsOf: new_listings)
            self.listingsCopy = listings
            self.currentPage += 1
        } catch {
            print("DEBUG: Failed to fetch listings with error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func updateListingsForLocation() {
        var filteredListings = listingsCopy
        
        if !searchLocation.isEmpty {
            filteredListings = filteredListings.filter({
                $0.city.lowercased() == searchLocation.lowercased() ||
                $0.state.lowercased() == searchLocation.lowercased()
            })
        }
        
        if let gender = selectedGender {
            filteredListings = filteredListings.filter({ $0.gender == gender })
        }
        
        switch sortOrder {
        case .priceAscending:
            filteredListings.sort { $0.pricePerMonth < $1.pricePerMonth }
        case .priceDescending:
            filteredListings.sort { $0.pricePerMonth > $1.pricePerMonth }
        case .none:
            break
        }
        
        self.listings = filteredListings
    }
}

enum SortOrder {
    case none
    case priceAscending
    case priceDescending
}
