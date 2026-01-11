import SwiftUI

struct ExploreView: View {
    @State private var showDestinationSearchView = false
    @StateObject var viewModel: ExploreViewModel
    @EnvironmentObject var authService: AuthService
    
    init() {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(service: ExploreService(), authService: AuthService.shared))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ModernDesignSystem.Colors.backgroundGradient.ignoresSafeArea()
                
                if showDestinationSearchView {
                    DestinationSearchView(show: $showDestinationSearchView,viewModel: viewModel)
                }else{
                    VStack{
                        SearchAndFilterBar(viewModel: viewModel, location: $viewModel.searchLocation)
                        
                        HStack {
                            Picker("Gender", selection: $viewModel.selectedGender) {
                                Text("All").tag(Gender?.none)
                                ForEach(Gender.allCases) { gender in
                                    Text(gender.description).tag(gender as Gender?)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .onChange(of: viewModel.selectedGender) { _ in
                                viewModel.updateListingsForLocation()
                            }
                            
                            Picker("Sort by", selection: $viewModel.sortOrder) {
                                Text("None").tag(SortOrder.none)
                                Text("Price ↑").tag(SortOrder.priceAscending)
                                Text("Price ↓").tag(SortOrder.priceDescending)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: viewModel.sortOrder) { _ in
                                viewModel.updateListingsForLocation()
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView {
                            if viewModel.isLoading && viewModel.listings.isEmpty {
                                // Initial loading state
                                VStack(spacing: 16) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                    Text("Loading listings...")
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            } else if let errorMessage = viewModel.errorMessage, viewModel.listings.isEmpty {
                                // Error state
                                VStack(spacing: 16) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 48))
                                        .foregroundColor(.red)

                                    Text(errorMessage)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.secondary)

                                    Button("Try Again") {
                                        viewModel.resetAndFetchListings()
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                .padding()
                            } else if viewModel.listings.isEmpty {
                                // Empty state
                                VStack(spacing: 16) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 64))
                                        .foregroundColor(.gray)

                                    Text("No listings found")
                                        .font(.title2)
                                        .fontWeight(.semibold)

                                    Text("Try adjusting your filters or search")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)

                                    if viewModel.selectedGender != nil || !viewModel.searchLocation.isEmpty || viewModel.sortOrder != .none {
                                        Button("Clear Filters") {
                                            viewModel.selectedGender = nil
                                            viewModel.searchLocation = ""
                                            viewModel.sortOrder = .none
                                        }
                                        .buttonStyle(.borderedProminent)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                LazyVStack(spacing: 16) {
                                    ForEach(viewModel.listings) { listing in
                                        NavigationLink(value: listing) {
                                            ListingItemView(listing: listing)
                                                .frame(height: 300)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .onAppear {
                                                    if listing.id == viewModel.listings.last?.id && viewModel.hasMorePages && !viewModel.isFetchingMore {
                                                        Task { await viewModel.fetchListings() }
                                                    }
                                                }
                                        }
                                    }

                                    // Loading indicator for pagination
                                    if viewModel.isFetchingMore {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .padding()
                                    }
                                }
                            }
                        }
                        .navigationDestination(for: Listing.self){ listing in
                            ListingDetailView(listing: listing)
                        }
                    }
                }
            }
        }
    }
    
    #Preview {
        ExploreView()
    }
}
