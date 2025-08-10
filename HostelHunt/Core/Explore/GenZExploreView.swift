import SwiftUI

// MARK: - Gen-Z Explore View
fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct GenZExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @State private var showFilters = false
    @State private var showProfile = false
    @State private var animateHeader = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showDestinationSearchView = false
    @EnvironmentObject var authService: AuthService
    
    init() {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(service: ExploreService()))
    }
    
    var body: some View {
        ZStack {
            // Clean Background
            GenZDesignSystem.Colors.background
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                // GeometryReader for scroll offset tracking
                GeometryReader { proxy in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                
                LazyVStack(spacing: GenZDesignSystem.Spacing.xl) {
                    // Hero Header Section
                    VStack(spacing: GenZDesignSystem.Spacing.lg) {
                        // Welcome Header with Animation
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hey there! 👋")
                                    .font(GenZDesignSystem.Typography.headlineMedium)
                                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                                    .opacity(animateHeader ? 1.0 : 0.0)
                                    .animation(GenZDesignSystem.Animation.smooth.delay(0.1), value: animateHeader)
                                
                                Text("Find your perfect hostel")
                                    .font(GenZDesignSystem.Typography.bodyLarge)
                                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                                    .opacity(animateHeader ? 1.0 : 0.0)
                                    .animation(GenZDesignSystem.Animation.smooth.delay(0.2), value: animateHeader)
                            }
                            
                            Spacer()
                            
                            // Profile Button
                            Button(action: { showProfile = true }) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(GenZDesignSystem.Colors.primary)
                                    .background(
                                        Circle()
                                            .fill(GenZDesignSystem.Colors.surface)
                                            .frame(width: 40, height: 40)
                                    )
                                    .genZShadow(GenZDesignSystem.Shadows.small)
                            }
                            .accessibilityLabel("View your profile")
                            .opacity(animateHeader ? 1.0 : 0.0)
                            .animation(GenZDesignSystem.Animation.smooth.delay(0.3), value: animateHeader)
                        }
                        .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                        
                        // Search Bar
                        GenZSearchBar(searchText: $viewModel.searchLocation)
                            .accessibilityLabel("Search for hostels, places, or cities")
                            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                            .scaleEffect(animateHeader ? 1.0 : 0.9)
                            .animation(GenZDesignSystem.Animation.elastic.delay(0.8), value: animateHeader)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    showDestinationSearchView.toggle()
                                }
                            }
                        
                        // Gender Filter Pills
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: GenZDesignSystem.Spacing.md) {
                                GenZFilterPill(title: "All", isSelected: viewModel.selectedGender == nil) {
                                    viewModel.selectedGender = nil
                                    viewModel.updateListingsForLocation()
                                }
                                
                                ForEach(Gender.allCases) { gender in
                                    GenZFilterPill(title: gender.description, isSelected: viewModel.selectedGender == gender) {
                                        viewModel.selectedGender = gender
                                        viewModel.updateListingsForLocation()
                                    }
                                }
                            }
                            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                        }
                        .opacity(animateHeader ? 1.0 : 0.0)
                        .animation(GenZDesignSystem.Animation.smooth.delay(0.4), value: animateHeader)
                    }
                    .padding(.top, GenZDesignSystem.Spacing.lg)
                    .offset(y: scrollOffset > 0 ? -min(scrollOffset, 50) : 0)
                    .opacity(max(0.5, 1.0 - (scrollOffset / 200.0)))
                    .opacity(max(0.0, 1.0 - (scrollOffset / 300.0)))
                    
                    // Listings Section
                    LazyVStack(spacing: GenZDesignSystem.Spacing.xl) {
                        ForEach(viewModel.listings) { listing in
                            NavigationLink(destination: ListingDetailView(listing: listing).navigationBarBackButtonHidden()) {
                                GenZListingCard(listing: listing)
                                    .onAppear {
                                        if listing == viewModel.listings.last {
                                            Task { await viewModel.fetchListings() }
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                    
                    if viewModel.isLoading {
                        GenZLoadingView()
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollOffset = value
            }
            .refreshable {
                // Pull to refresh functionality
                await refreshContent()
            }
            
            // Floating Action Buttons
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: GenZDesignSystem.Spacing.md) {
                        // Filter Button
                        Button(action: { showFilters = true }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(GenZDesignSystem.Colors.accent)
                                )
                                .genZShadow(GenZDesignSystem.Shadows.medium)
                        }
                        .accessibilityLabel("Show filters")
                        
                        // Map Button
                        Button(action: {}) {
                            Image(systemName: "map")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(GenZDesignSystem.Colors.primary)
                                )
                                .genZShadow(GenZDesignSystem.Shadows.medium)
                        }
                        .accessibilityLabel("Show map view")
                    }
                }
                .padding(.trailing, GenZDesignSystem.Spacing.lg)
                .padding(.bottom, 100) // Account for tab bar
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            animateHeader = true
        }
        .sheet(isPresented: $showDestinationSearchView) {
            DestinationSearchView(show: $showDestinationSearchView, viewModel: viewModel)
        }
        .sheet(isPresented: $showFilters) {
            FilterView(filters: .constant(SearchFilters())) {
                // Apply filters
                viewModel.updateListingsForLocation()
            }
        }
        .sheet(isPresented: $showProfile) {
            GenZProfileView()
        }
    }
    
    private func refreshContent() async {
        // Simulate refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await viewModel.fetchListings()
    }
}

// MARK: - Gen-Z Quick Filter Chip
struct GenZQuickFilterChip: View {
    let filter: QuickFilter
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(style: .light)
            action()
        }) {
            HStack(spacing: GenZDesignSystem.Spacing.sm) {
                Image(systemName: filter.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(filter.rawValue)
                    .font(GenZDesignSystem.Typography.labelMedium)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            .background(GenZDesignSystem.Colors.surface)
            .cornerRadius(GenZDesignSystem.CornerRadius.pill)
            .genZShadow(GenZDesignSystem.Shadows.small)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(GenZDesignSystem.Animation.bouncy, value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Filter by \(filter.rawValue)")
    }
}

// MARK: - Gen-Z Suggestions Section
struct GenZSuggestionsSection: View {
    @ObservedObject var searchService: SearchService
    
    var body: some View {
        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.xl) {
            // Trending Section
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
                HStack {
                    Text("🔥 Trending Now")
                        .font(GenZDesignSystem.Typography.headlineSmall)
                        .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                    
                    Spacer()
                    
                    Button("See All") {
                        // TODO: Show all trending
                    }
                    .font(GenZDesignSystem.Typography.labelMedium)
                    .foregroundColor(GenZDesignSystem.Colors.primary)
                }
                .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: GenZDesignSystem.Spacing.lg) {
                        ForEach(0..<5) { index in
                            GenZTrendingCard(index: index)
                        }
                    }
                    .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                }
            }
            
            // Popular Searches
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
                Text("💡 Popular Searches")
                    .font(GenZDesignSystem.Typography.headlineSmall)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                    .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: GenZDesignSystem.Spacing.md), count: 2),
                    spacing: GenZDesignSystem.Spacing.md
                ) {
                    ForEach(searchService.popularSearches, id: \.self) { search in
                        GenZPopularSearchCard(text: search) {
                            searchService.searchText = search
                        }
                    }
                }
                .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            }
            
            // Recent Activity
            if !searchService.recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
                    HStack {
                        Text("⏰ Recent Searches")
                            .font(GenZDesignSystem.Typography.headlineSmall)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                        
                        Spacer()
                        
                        Button("Clear") {
                            searchService.clearRecentSearches()
                        }
                        .font(GenZDesignSystem.Typography.labelMedium)
                        .foregroundColor(GenZDesignSystem.Colors.error)
                    }
                    .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                    
                    ForEach(Array(searchService.recentSearches.prefix(5)), id: \.self) { search in
                        GenZRecentSearchRow(text: search) {
                            searchService.searchText = search
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Gen-Z Trending Card
struct GenZTrendingCard: View {
    let index: Int
    @State private var animateGradient = false
    
    private let gradients = [
        GenZDesignSystem.Colors.gradientPrimary,
        GenZDesignSystem.Colors.gradientAccent,
        GenZDesignSystem.Colors.gradientPrimary,
        GenZDesignSystem.Colors.gradientAccent,
        GenZDesignSystem.Colors.gradientSuccess
    ]
    
    private let emojis = ["🏠", "🌟", "🔥", "💎", "⚡"]
    private let titles = ["Cozy Hostels", "Premium Stays", "Hot Deals", "Luxury PGs", "Quick Book"]
    
    var body: some View {
        VStack(spacing: GenZDesignSystem.Spacing.md) {
            Text(emojis[index])
                .font(.system(size: 40))
                .scaleEffect(animateGradient ? 1.1 : 1.0)
                .animation(
                    GenZDesignSystem.Animation.bouncy.repeatForever(autoreverses: true),
                    value: animateGradient
                )
            
            Text(titles[index])
                .font(GenZDesignSystem.Typography.titleMedium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140, height: 120)
        .background(
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                .fill(gradients[index])
                .genZShadow(GenZDesignSystem.Shadows.large)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                animateGradient = true
            }
        }
    }
}

// MARK: - Gen-Z Popular Search Card
struct GenZPopularSearchCard: View {
    let text: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(GenZDesignSystem.Colors.primary)
            }
            .padding(GenZDesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.surface)
                    .genZShadow(isPressed ? GenZDesignSystem.Shadows.small : GenZDesignSystem.Shadows.medium)
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(GenZDesignSystem.Animation.quick, value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

// MARK: - Gen-Z Recent Search Row
struct GenZRecentSearchRow: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                
                Text(text)
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12))
                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.md)
                    .fill(GenZDesignSystem.Colors.surface.opacity(0.5))
            )
        }
        .padding(.horizontal, GenZDesignSystem.Spacing.lg)
    }
}

// MARK: - Gen-Z Search Results Section
struct GenZSearchResultsSection: View {
    @ObservedObject var searchService: SearchService
    @State private var animatedListings: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.lg) {
            // Results Header
            HStack {
                Text("Search Results")
                    .font(GenZDesignSystem.Typography.headlineSmall)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                if !searchService.searchResults.isEmpty {
                    Text("\(searchService.searchResults.count) found")
                        .font(GenZDesignSystem.Typography.bodySmall)
                        .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                }
            }
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            
            // Results Content
            if searchService.isLoading {
                GenZLoadingView()
            } else if searchService.searchResults.isEmpty {
                GenZEmptySearchView()
            } else {
                LazyVStack(spacing: GenZDesignSystem.Spacing.lg) {
//                    let enumeratedResults = Array(searchService.searchResults.enumerated())
//                    ForEach(enumeratedResults, id: \.element.id) { index, listing in
//                        GenZListingCard(listing: listing)
//                            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
//                            .opacity(animatedListings.contains(listing.id) ? 1 : 0)
//                            .offset(y: animatedListings.contains(listing.id) ? 0 : 20)
//                            .onAppear {
//                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1)) {
//                                    animatedListings.insert(listing.id)
//                                }
//                            }
//                    }
                }
                .onChange(of: searchService.searchResults) { _ in
                    // Reset animation when search results change
                    animatedListings.removeAll()
                }
            }
        }
    }
}

// MARK: - Gen-Z Loading View
struct GenZLoadingView: View {
    @State private var animateGradient = false
    
    var body: some View {
        VStack(spacing: GenZDesignSystem.Spacing.xl) {
            // Clean Loading Indicator
            ZStack {
                Circle()
                    .stroke(GenZDesignSystem.Colors.backgroundSecondary, lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        GenZDesignSystem.Colors.primary,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(animateGradient ? 360 : 0))
                    .animation(
                        GenZDesignSystem.Animation.smooth.repeatForever(autoreverses: false),
                        value: animateGradient
                    )
            }
            
            VStack(spacing: GenZDesignSystem.Spacing.sm) {
                Text("Finding amazing hostels...")
                    .font(GenZDesignSystem.Typography.titleMedium)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("This won't take long! ⚡")
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .onAppear {
            animateGradient = true
        }
    }
}

// MARK: - Gen-Z Empty Search View
struct GenZEmptySearchView: View {
    var body: some View {
        VStack(spacing: GenZDesignSystem.Spacing.xl) {
            Text("🔍")
                .font(.system(size: 80))
            
            VStack(spacing: GenZDesignSystem.Spacing.md) {
                Text("No hostels found")
                    .font(GenZDesignSystem.Typography.headlineMedium)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("Try adjusting your search or filters\nto find the perfect place!")
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Clear Search") {
                // TODO: Clear search
            }
            .primaryButton()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding(GenZDesignSystem.Spacing.xl)
    }
}

// MARK: - Gen-Z Profile View (Placeholder)
struct GenZProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Coming Soon! 🚀")
                    .font(GenZDesignSystem.Typography.headlineLarge)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GenZDesignSystem.Colors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
