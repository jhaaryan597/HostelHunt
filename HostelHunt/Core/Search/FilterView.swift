import SwiftUI

struct FilterView: View {
    @Binding var filters: SearchFilters
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var tempFilters: SearchFilters

    init(filters: Binding<SearchFilters>, onApply: @escaping () -> Void) {
        self._filters = filters
        self.onApply = onApply
        self._tempFilters = State(initialValue: filters.wrappedValue)
    }

    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(spacing: GenZDesignSystem.Spacing.lg) {
                        priceRangeFilter
                        genderFilter
                        accommodationTypeFilter
                        amenitiesFilter
                        ratingFilter
                    }
                    .padding()
                }
                
                footer
            }
        }
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack {
            Text("Filters")
                .font(GenZDesignSystem.Typography.displaySmall)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            Spacer()
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .padding(GenZDesignSystem.Spacing.sm)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    
            }
        }
        .padding()
    }
    
    private var footer: some View {
        HStack {
            Button("Reset") {
                tempFilters = SearchFilters()
            }
            .ghostButton()
            
            Button("Apply Filters") {
                filters = tempFilters
                onApply()
                dismiss()
            }
            .primaryButton()
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    private var priceRangeFilter: some View {
        GenZFilterSection(title: "Price Range", icon: "dollarsign.circle.fill") {
            VStack {
                HStack {
                    Text("₹\(Int(tempFilters.priceRange.lowerBound))")
                    Spacer()
                    Text("₹\(Int(tempFilters.priceRange.upperBound))")
                }
                .font(GenZDesignSystem.Typography.subheadline)
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                
                GenZRangeSlider(
                    range: $tempFilters.priceRange,
                    bounds: 5000...50000,
                    step: 1000
                )
            }
        }
    }
    
    private var genderFilter: some View {
        GenZFilterSection(title: "Gender", icon: "person.2.fill") {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    GenZSelectableChip(
                        text: gender.description,
                        isSelected: tempFilters.gender == gender
                    ) {
                        tempFilters.gender = tempFilters.gender == gender ? nil : gender
                    }
                }
            }
        }
    }
    
    private var accommodationTypeFilter: some View {
        GenZFilterSection(title: "Accomodation", icon: "house.fill") {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                ForEach(ListingType.allCases, id: \.self) { type in
                    GenZSelectableChip(
                        text: type.description,
                        isSelected: tempFilters.type == type
                    ) {
                        tempFilters.type = tempFilters.type == type ? nil : type
                    }
                }
            }
        }
    }
    
    private var amenitiesFilter: some View {
        GenZFilterSection(title: "Amenities", icon: "star.fill") {
            let columns = [GridItem(.adaptive(minimum: 120))]
            LazyVGrid(columns: columns, spacing: GenZDesignSystem.Spacing.md) {
                ForEach(ListingAmenities.allCases, id: \.self) { amenity in
                    GenZSelectableChip(
                        text: amenity.title,
                        icon: amenity.imageName,
                        isSelected: tempFilters.amenities.contains(amenity)
                    ) {
                        if tempFilters.amenities.contains(amenity) {
                            tempFilters.amenities.remove(amenity)
                        } else {
                            tempFilters.amenities.insert(amenity)
                        }
                    }
                }
            }
        }
    }
    
    private var ratingFilter: some View {
        GenZFilterSection(title: "Rating", icon: "star.leading.fill") {
            HStack {
                ForEach(1...5, id: \.self) { rating in
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(rating <= Int(tempFilters.rating) ? GenZDesignSystem.Colors.primary : GenZDesignSystem.Colors.textTertiary.opacity(0.5))
                        .onTapGesture {
                            tempFilters.rating = Double(rating)
                        }
                        .animation(GenZDesignSystem.Animation.bouncy, value: tempFilters.rating)
                }
                Spacer()
                if tempFilters.rating > 0 {
                    Button("Clear") {
                        tempFilters.rating = 0
                    }
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Subviews

private struct GenZFilterSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                    .shadow(color: GenZDesignSystem.Colors.primary.opacity(0.5), radius: 5, y: 5)
                Text(title)
                    .font(GenZDesignSystem.Typography.title2)
            }
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)

            content
        }
        .padding()
        .background(GenZDesignSystem.Colors.glassPrimary)
        .cornerRadius(GenZDesignSystem.CornerRadius.xl)
    }
}

private struct GenZSelectableChip: View {
    let text: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: GenZDesignSystem.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(text)
            }
            .font(GenZDesignSystem.Typography.body)
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                        .fill(isSelected ? GenZDesignSystem.Colors.glassSecondary : GenZDesignSystem.Colors.glassPrimary)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                            .stroke(GenZDesignSystem.Colors.primary, lineWidth: 1)
                            .blur(radius: 2)
                    }
                }
            )
            .animation(GenZDesignSystem.Animation.bouncy, value: isSelected)
        }
    }
}

private struct GenZRangeSlider: View {
    @Binding var range: ClosedRange<Int>
    let bounds: ClosedRange<Int>
    let step: Int

    @State private var lower: Double
    @State private var upper: Double

    init(range: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>, step: Int) {
        self._range = range
        self.bounds = bounds
        self.step = step
        _lower = State(initialValue: Double(range.wrappedValue.lowerBound))
        _upper = State(initialValue: Double(range.wrappedValue.upperBound))
    }

    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let lowerBound = Double(bounds.lowerBound)
            let upperBound = Double(bounds.upperBound)
            let rangeWidth = upperBound - lowerBound

            let lowerPosition = (lower - lowerBound) / rangeWidth * trackWidth
            let upperPosition = (upper - lowerBound) / rangeWidth * trackWidth

            ZStack(alignment: .leading) {
                // Inactive track
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)

                // Active track
                RoundedRectangle(cornerRadius: 3)
                    .fill(GenZDesignSystem.Colors.gradientPrimary)
                    .frame(width: upperPosition - lowerPosition, height: 6)
                    .offset(x: lowerPosition)

                // Lower thumb
                ThumbView(position: lowerPosition, value: $lower, bounds: lowerBound...upper, trackWidth: trackWidth)

                // Upper thumb
                ThumbView(position: upperPosition, value: $upper, bounds: lower...upperBound, trackWidth: trackWidth)
            }
            .onChange(of: lower) { updateRange() }
            .onChange(of: upper) { updateRange() }
        }
        .frame(height: 30)
    }

    private func updateRange() {
        let newLower = Int(lower / Double(step)) * step
        let newUpper = Int(upper / Double(step)) * step
        range = newLower...newUpper
    }

    private struct ThumbView: View {
        var position: CGFloat
        @Binding var value: Double
        var bounds: ClosedRange<Double>
        var trackWidth: CGFloat

        var body: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
                .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 1))
                .offset(x: position - 12)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let dragPosition = gesture.location.x
                            let newValue = (dragPosition / trackWidth) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound
                            value = min(max(newValue, bounds.lowerBound), bounds.upperBound)
                        }
                )
        }
    }
}

// MARK: - Extensions for Filter Support

extension ListingType: CaseIterable {
    public static var allCases: [ListingType] {
        return [.hostel, .pg, .coliving]
    }
}
