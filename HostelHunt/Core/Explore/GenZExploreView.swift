import SwiftUI

struct GenZExploreView: View {
    @StateObject private var viewModel = ExploreViewModel(service: ExploreService())
    
    var body: some View {
        NavigationStack {
            ZStack {
                GenZDesignSystem.Colors.auroraBackground.ignoresSafeArea()
                
                VStack {
                    searchBar
                    genderFilters
                    listingsGrid
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var searchBar: some View {
        FuturisticTextField(placeholder: "Search destinations...", text: $viewModel.searchLocation)
            .padding(.horizontal)
    }

    private var genderFilters: some View {
        HStack(spacing: GenZDesignSystem.Spacing.md) {
            ForEach(Gender.allCases, id: \.self) { gender in
                GenderFilterButton(
                    gender: gender,
                    isSelected: viewModel.selectedGender == gender,
                    action: {
                        if viewModel.selectedGender == gender {
                            viewModel.selectedGender = nil
                        } else {
                            viewModel.selectedGender = gender
                        }
                    }
                )
            }
        }
        .padding(.horizontal)
    }

    private var listingsGrid: some View {
        ScrollView {
            LazyVStack(spacing: GenZDesignSystem.Spacing.sm) {
                ForEach(viewModel.listings) { listing in
                    NavigationLink(destination: ListingDetailView(listing: listing)) {
                        FuturisticCard {
                            ListingItemView(listing: listing)
                                .padding()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GenderFilterButton: View {
    let gender: Gender
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        if isSelected {
            Button(action: action) {
                Text(gender.description)
            }
            .buttonStyle(FuturisticPrimaryButton())
        } else {
            Button(action: action) {
                Text(gender.description)
            }
            .buttonStyle(FuturisticAccentButton())
        }
    }
}
