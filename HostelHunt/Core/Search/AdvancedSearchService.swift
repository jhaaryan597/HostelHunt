import SwiftUI
import Combine

// MARK: - Search Filters
struct SearchFilters: Codable {
    var priceRange: ClosedRange<Int> = 5000...50000
    var gender: Gender?
    var type: ListingType?
    var amenities: Set<ListingAmenities> = []
    var features: Set<ListingFeatures> = []
    var rating: Double = 0.0
    var location: String = ""
    var maxDistance: Double = 10.0 // km
    var availableFrom: Date?
    var duration: AccommodationDuration = .semester
    
    enum AccommodationDuration: String, CaseIterable, Codable {
        case monthly = "Monthly"
        case semester = "Semester"
        case yearly = "Yearly"
        
        var months: Int {
            switch self {
            case .monthly: return 1
            case .semester: return 6
            case .yearly: return 12
            }
        }
    }
}

// MARK: - Search Service
class SearchService: ObservableObject {
    @Published var searchText = ""
    @Published var filters = SearchFilters()
    @Published var searchResults: [Listing] = []
    @Published var isLoading = false
    @Published var aiRecommendations: [Listing] = []
    @Published var recentSearches: [String] = []
    @Published var popularSearches: [String] = [
        "Near IIT Delhi",
        "Girls hostel Bangalore",
        "PG with meals Mumbai",
        "Co-ed hostel Pune",
        "Budget hostel Chennai"
    ]
    
    private var cancellables = Set<AnyCancellable>()
    private let errorHandler = ErrorHandler.shared
    
    init() {
        setupSearchDebouncing()
        loadRecentSearches()
    }
    
    private func setupSearchDebouncing() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                let results = try await searchListings()
                
                await MainActor.run {
                    self.searchResults = results
                    self.isLoading = false
                    self.saveRecentSearch(searchText)
                    
                    // Generate AI recommendations if enabled
                    if EnvironmentConfig.shared.isAIRecommendationsEnabled {
                        self.generateAIRecommendations()
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorHandler.handle(error)
                }
            }
        }
    }
    
    private func searchListings() async throws -> [Listing] {
        // Build search query
        var query = SupabaseManager.shared.client
            .from("listings")
            .select()
        
        // Apply text search
        if !searchText.isEmpty {
            query = query.or("title.ilike.%\(searchText)%,city.ilike.%\(searchText)%,address.ilike.%\(searchText)%")
        }
        
        // Apply filters
        if let gender = filters.gender {
            query = query.eq("gender", value: gender.rawValue)
        }
        
        if let type = filters.type {
            query = query.eq("type", value: type.rawValue)
        }
        
        query = query
            .gte("pricePerMonth", value: filters.priceRange.lowerBound)
            .lte("pricePerMonth", value: filters.priceRange.upperBound)
            .gte("rating", value: filters.rating)
        
        let response: [Listing] = try await query.execute().value
        return response.sorted { $0.rating > $1.rating }
    }
    
    private func generateAIRecommendations() {
        // Simulate AI recommendations based on user preferences
        // In production, this would call an AI service
        Task {
            await MainActor.run {
                self.aiRecommendations = Array(self.searchResults.prefix(3))
            }
        }
    }
    
    private func saveRecentSearch(_ search: String) {
        if !recentSearches.contains(search) {
            recentSearches.insert(search, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: "RecentSearches")
    }
    
    func applyQuickFilter(_ quickFilter: QuickFilter) {
        switch quickFilter {
        case .nearMe:
            // TODO: Implement location-based search
            break
        case .budgetFriendly:
            filters.priceRange = 5000...15000
        case .premium:
            filters.priceRange = 25000...50000
        case .highRated:
            filters.rating = 4.0
        case .withMeals:
            filters.features.insert(.mealService)
        case .verified:
            filters.features.insert(.verified)
        }
        performSearch()
    }
}

// MARK: - Quick Filters
enum QuickFilter: String, CaseIterable, Identifiable {
    case nearMe = "Near Me"
    case budgetFriendly = "Budget Friendly"
    case premium = "Premium"
    case highRated = "High Rated"
    case withMeals = "With Meals"
    case verified = "Verified Hostels"

    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .nearMe: return "location.fill"
        case .budgetFriendly: return "dollarsign.circle.fill"
        case .premium: return "crown.fill"
        case .highRated: return "star.fill"
        case .withMeals: return "fork.knife.circle.fill"
        case .verified: return "checkmark.seal.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .nearMe: return .blue
        case .budgetFriendly: return .green
        case .premium: return .purple
        case .highRated: return .orange
        case .withMeals: return .red
        case .verified: return .mint
        }
    }
}

// MARK: - Advanced Search View
struct AdvancedSearchView: View {
    @StateObject private var searchService = SearchService()
    @State private var showFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Header
                VStack(spacing: GenZDesignSystem.Spacing.md) {
                    AnimatedSearchBar(searchText: $searchService.searchText)
                    
                    // Quick Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: GenZDesignSystem.Spacing.sm) {
                            ForEach(QuickFilter.allCases, id: \.rawValue) { filter in
                                QuickFilterChip(filter: filter) {
                                    searchService.applyQuickFilter(filter)
                                }
                            }
                        }
                        .padding(.horizontal, GenZDesignSystem.Spacing.md)
                    }
                }
                .padding(.vertical, GenZDesignSystem.Spacing.md)
                .background(GenZDesignSystem.Colors.background)
                
                // Content
                if searchService.searchText.isEmpty {
                    SearchSuggestionsView(searchService: searchService)
                } else {
                    SearchResultsView(searchService: searchService)
                }
            }
            .navigationTitle("Find Your Perfect Stay")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterView(filters: $searchService.filters) {
                    searchService.performSearch()
                }
            }
        }
    }
}

// MARK: - Quick Filter Chip
struct QuickFilterChip: View {
    let filter: QuickFilter
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: GenZDesignSystem.Spacing.xs) {
                Image(systemName: filter.icon)
                    .font(.caption)
                Text(filter.rawValue)
                    .font(GenZDesignSystem.Typography.labelSmall)
            }
            .foregroundColor(.white)
            .padding(.horizontal, GenZDesignSystem.Spacing.md)
            .padding(.vertical, GenZDesignSystem.Spacing.sm)
            .background(
                Capsule()
                    .fill(filter.color)
            )
        }
    }
}

// MARK: - Search Suggestions View
struct SearchSuggestionsView: View {
    @ObservedObject var searchService: SearchService
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
                // AI Recommendations
                if !searchService.aiRecommendations.isEmpty {
                    VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(GenZDesignSystem.Colors.primary)
                            Text("AI Recommendations")
                                .font(GenZDesignSystem.Typography.headlineSmall)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: GenZDesignSystem.Spacing.md) {
                                ForEach(searchService.aiRecommendations, id: \.id) { listing in
                                    FuturisticListingCard(listing: listing)
                                        .frame(width: 280)
                                }
                            }
                            .padding(.horizontal, GenZDesignSystem.Spacing.md)
                        }
                    }
                }
                
                // Popular Searches
                VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
                    Text("Popular Searches")
                        .font(GenZDesignSystem.Typography.headlineSmall)
                        .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        .padding(.horizontal, GenZDesignSystem.Spacing.md)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: GenZDesignSystem.Spacing.sm) {
                        ForEach(searchService.popularSearches, id: \.self) { search in
                            SearchSuggestionCard(text: search) {
                                searchService.searchText = search
                            }
                        }
                    }
                    .padding(.horizontal, GenZDesignSystem.Spacing.md)
                }
                
                // Recent Searches
                if !searchService.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
                        HStack {
                            Text("Recent Searches")
                                .font(GenZDesignSystem.Typography.headlineSmall)
                                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            
                            Spacer()
                            
                            Button("Clear") {
                                searchService.clearRecentSearches()
                            }
                            .font(GenZDesignSystem.Typography.labelMedium)
                            .foregroundColor(GenZDesignSystem.Colors.primary)
                        }
                        .padding(.horizontal, GenZDesignSystem.Spacing.md)
                        
                        ForEach(searchService.recentSearches, id: \.self) { search in
                            RecentSearchRow(text: search) {
                                searchService.searchText = search
                            }
                        }
                    }
                }
            }
            .padding(.vertical, GenZDesignSystem.Spacing.md)
        }
    }
}

// MARK: - Search Suggestion Card
struct SearchSuggestionCard: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(GenZDesignSystem.Typography.body)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(GenZDesignSystem.Spacing.md)
                .background(GenZDesignSystem.Colors.surface)
                .cornerRadius(GenZDesignSystem.CornerRadius.md)
        }
    }
}

// MARK: - Recent Search Row
struct RecentSearchRow: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                    .font(.system(size: 16))
                
                Text(text)
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, GenZDesignSystem.Spacing.md)
            .padding(.vertical, GenZDesignSystem.Spacing.sm)
        }
    }
}

// MARK: - Search Results View
struct SearchResultsView: View {
    @ObservedObject var searchService: SearchService
    
    var body: some View {
        Group {
            if searchService.isLoading {
                LoadingView()
            } else if searchService.searchResults.isEmpty {
                EmptySearchView()
            } else {
                ScrollView {
                    LazyVStack(spacing: GenZDesignSystem.Spacing.md) {
                        ForEach(searchService.searchResults, id: \.id) { listing in
                            FuturisticListingCard(listing: listing)
                        }
                    }
                    .padding(GenZDesignSystem.Spacing.md)
                }
            }
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: GenZDesignSystem.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(GenZDesignSystem.Colors.primary)
            
            Text("Finding perfect hostels for you...")
                .font(GenZDesignSystem.Typography.body)
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Empty Search View
struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: GenZDesignSystem.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(GenZDesignSystem.Colors.textTertiary)
            
            VStack(spacing: GenZDesignSystem.Spacing.sm) {
                Text("No Results Found")
                    .font(GenZDesignSystem.Typography.headlineMedium)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("Try adjusting your search or filters")
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(GenZDesignSystem.Spacing.xl)
    }
}
