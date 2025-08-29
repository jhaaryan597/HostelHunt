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
    private var listingsByGender = [Gender: [Listing]]()
    private var currentPageByGender = [Gender: Int]()
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
                        self?.listingsByGender = [:]
                        self?.currentPageByGender = [:]
                    }
                }
            }
            .store(in: &cancellables)
        
        $searchLocation
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.updateListingsForLocation()
            }
            .store(in: &cancellables)
        
        $selectedGender
            .sink { [weak self] _ in
                self?.updateListingsForLocation()
            }
            .store(in: &cancellables)
    }
    
    func fetchListings() async {
        guard authService.user != nil else { return }
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let allListings = try await service.fetchListings(page: 0, limit: 100) // Fetch all for simplicity
            listingsByGender = Dictionary(grouping: allListings, by: { $0.gender })
            updateListingsForLocation()
        } catch {
            print("DEBUG: Failed to fetch listings with error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func updateListingsForLocation() {
        var filteredListings: [Listing]
        
        if let gender = selectedGender {
            filteredListings = listingsByGender[gender] ?? []
        } else {
            filteredListings = Array(listingsByGender.values.flatMap { $0 })
        }
        
        if !searchLocation.isEmpty {
            filteredListings = filteredListings.filter({
                $0.city.lowercased() == searchLocation.lowercased() ||
                $0.state.lowercased() == searchLocation.lowercased()
            })
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
