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
            if showDestinationSearchView {
                DestinationSearchView(show: $showDestinationSearchView,viewModel: viewModel)
            }else{
                VStack{
                    SearchAndFilterBar(location: $viewModel.searchLocation)
                        .onTapGesture {
                            withAnimation(.snappy){
                                showDestinationSearchView.toggle()
                            }
                        }
                    
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
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.listings) { listing in
                            NavigationLink(value: listing) {
                                ListingItemView(listing: listing)
                                    .frame(height: 410)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onAppear {
                                        if listing == viewModel.listings.last {
                                            Task { await viewModel.fetchListings() }
                                        }
                                    }
                            }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }
                .navigationDestination(for: Listing.self){ listing in
                    ListingDetailView(listing: listing)
                        .navigationBarBackButtonHidden()
                }
            }
            }
        }
    }
}

#Preview {
    ExploreView()
}
