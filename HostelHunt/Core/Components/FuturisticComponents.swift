import SwiftUI

// MARK: - Futuristic Listing Card
struct FuturisticListingCard: View {
    let listing: Listing
    @State private var isPressed = false
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section with Overlay
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: listing.imageURLs.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                        .fill(DesignSystem.Colors.surfaceSecondary)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        )
                }
                .frame(height: 200)
                .clipped()
                
                // Floating Action Buttons
                HStack(spacing: DesignSystem.Spacing.sm) {
                    // Wishlist Button
                    Button(action: {}) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .backdrop(blur: 10)
                            )
                    }
                    
                    // Share Button
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .backdrop(blur: 10)
                            )
                    }
                }
                .padding(DesignSystem.Spacing.md)
                
                // Price Badge
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("₹\(listing.pricePerMonth)/month")
                            .font(DesignSystem.Typography.labelLarge)
                            .foregroundColor(.white)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(DesignSystem.Colors.gradientPrimary)
                                    .applyShadow(DesignSystem.Shadows.medium)
                            )
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
            .cornerRadius(DesignSystem.CornerRadius.lg, corners: [.topLeft, .topRight])
            
            // Content Section
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                // Title and Rating
                HStack {
                    Text(listing.title)
                        .font(DesignSystem.Typography.titleMedium)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.warning)
                        Text(String(format: "%.1f", listing.rating))
                            .font(DesignSystem.Typography.labelSmall)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                
                // Location
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textTertiary)
                    Text("\(listing.city), \(listing.state)")
                        .font(DesignSystem.Typography.bodySmall)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .lineLimit(1)
                }
                
                // Features
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        ForEach(listing.features, id: \.id) { feature in
                            FeatureChip(feature: feature)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                // Gender and Type
                HStack {
                    GenderBadge(gender: listing.gender)
                    TypeBadge(type: listing.type)
                    Spacer()
                }
            }
            .padding(DesignSystem.Spacing.md)
        }
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.CornerRadius.lg)
        .applyShadow(isPressed ? DesignSystem.Shadows.small : DesignSystem.Shadows.medium)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(DesignSystem.Animation.spring, value: isPressed)
        .onTapGesture {
            showDetails = true
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

// MARK: - Feature Chip
struct FeatureChip: View {
    let feature: ListingFeatures
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: feature.imageName)
                .font(.caption2)
            Text(feature.title)
                .font(DesignSystem.Typography.labelSmall)
        }
        .foregroundColor(DesignSystem.Colors.primary)
        .padding(.horizontal, DesignSystem.Spacing.sm)
        .padding(.vertical, DesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(DesignSystem.Colors.primary.opacity(0.1))
        )
    }
}

// MARK: - Gender Badge
struct GenderBadge: View {
    let gender: Gender
    
    var body: some View {
        Text(gender.description)
            .font(DesignSystem.Typography.labelSmall)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                Capsule()
                    .fill(genderColor)
            )
    }
    
    private var genderColor: Color {
        switch gender {
        case .male:
            return .blue
        case .female:
            return .pink
        case .coed:
            return .purple
        }
    }
}

// MARK: - Type Badge
struct TypeBadge: View {
    let type: ListingType
    
    var body: some View {
        Text(type.description)
            .font(DesignSystem.Typography.labelSmall)
            .foregroundColor(DesignSystem.Colors.textSecondary)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                Capsule()
                    .stroke(DesignSystem.Colors.textTertiary, lineWidth: 1)
            )
    }
}

// MARK: - Animated Search Bar
struct AnimatedSearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(DesignSystem.Colors.textTertiary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search hostels, PGs...", text: $searchText)
                    .font(DesignSystem.Typography.bodyMedium)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .onTapGesture {
                        withAnimation(DesignSystem.Animation.smooth) {
                            isEditing = true
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DesignSystem.Colors.textTertiary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                    .fill(DesignSystem.Colors.surface)
                    .applyShadow(DesignSystem.Shadows.small)
            )
            
            if isEditing {
                Button("Cancel") {
                    withAnimation(DesignSystem.Animation.smooth) {
                        isEditing = false
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .font(DesignSystem.Typography.labelMedium)
                .foregroundColor(DesignSystem.Colors.primary)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(DesignSystem.Animation.smooth, value: isEditing)
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(DesignSystem.Colors.gradientPrimary)
                        .applyShadow(isPressed ? DesignSystem.Shadows.small : DesignSystem.Shadows.large)
                )
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(DesignSystem.Animation.bouncy, value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

// MARK: - Glass Morphism Card
struct GlassMorphismCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .fill(Color.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .backdrop(blur: 20)
            )
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
