import Foundation
import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var listings = [Listing]()
    @Published var searchLocation = ""
    @Published var selectedGender: Gender?
    @Published var sortOrder: SortOrder = .none
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    @Published var isFetchingMore = false

    private let service: ExploreService
    private let authService: AuthService
    private var allFetchedListings = [Listing]()
    private var listingsByGender = [Gender: [Listing]]()
    private var currentPage = 0
    private let listingsPerPage = 10
    private var cancellables = Set<AnyCancellable>()

    init(service: ExploreService, authService: AuthService = .shared) {
        self.service = service
        self.authService = authService

        Task { await fetchListings() }

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

        $sortOrder
            .sink { [weak self] _ in
                self?.updateListingsForLocation()
            }
            .store(in: &cancellables)
    }

    func fetchListings() async {
        guard !isLoading && !isFetchingMore else { return }

        if currentPage == 0 {
            isLoading = true
        } else {
            isFetchingMore = true
        }

        errorMessage = nil

        do {
            let newListings = try await service.fetchListings(page: currentPage, limit: listingsPerPage)

            if newListings.isEmpty {
                hasMorePages = false
            } else {
                allFetchedListings.append(contentsOf: newListings)
                listingsByGender = Dictionary(grouping: allFetchedListings, by: { $0.gender })
                currentPage += 1
                updateListingsForLocation()
            }
        } catch {
            errorMessage = "Failed to load listings. Please check your connection and try again."
            print("DEBUG: Failed to fetch listings with error: \(error.localizedDescription)")
        }

        isLoading = false
        isFetchingMore = false
    }

    func resetAndFetchListings() {
        currentPage = 0
        hasMorePages = true
        allFetchedListings = []
        listingsByGender = [:]
        listings = []
        Task { await fetchListings() }
    }

    func updateListingsForLocation() {
        // Don't filter while fetching new data
        guard !isLoading else { return }

        var filteredListings: [Listing]

        if let gender = selectedGender {
            filteredListings = listingsByGender[gender] ?? []
        } else {
            filteredListings = Array(listingsByGender.values.flatMap { $0 })
        }

        if !searchLocation.isEmpty {
            filteredListings = filteredListings.filter({
                $0.city.lowercased().contains(searchLocation.lowercased()) ||
                $0.state.lowercased().contains(searchLocation.lowercased()) ||
                $0.address.lowercased().contains(searchLocation.lowercased())
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
