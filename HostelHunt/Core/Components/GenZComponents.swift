import SwiftUI

// MARK: - Gen-Z Listing Card
struct GenZListingCard: View {
    let listing: Listing
    @State private var isPressed = false
    @State private var isLiked = false
    @State private var showDetails = false
    @State private var animateGradient = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero Image Section
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: listing.imageURLs.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                        .fill(GenZDesignSystem.Colors.backgroundSecondary)
                        .overlay(
                            VStack {
                                Image(systemName: "photo.artframe")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                                Text("Loading...")
                                    .font(GenZDesignSystem.Typography.caption)
                                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                            }
                        )
                }
                .frame(height: 220)
                .clipped()
                
                // Floating Action Buttons
                VStack(spacing: GenZDesignSystem.Spacing.sm) {
                    // Like Button with Animation
                    Button(action: {
                        withAnimation(GenZDesignSystem.Animation.smooth) {
                            isLiked.toggle()
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isLiked ? GenZDesignSystem.Colors.error : .white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.4))
                            )
                            .genZShadow(GenZDesignSystem.Shadows.small)
                            .scaleEffect(isLiked ? 1.1 : 1.0)
                            .animation(GenZDesignSystem.Animation.smooth, value: isLiked)
                    }
                    
                    // Share Button
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.4))
                            )
                            .genZShadow(GenZDesignSystem.Shadows.small)
                    }
                }
                .padding(GenZDesignSystem.Spacing.md)
                
                // Price Badge with Gradient Animation
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("₹\(listing.pricePerMonth)/month")
                            .font(GenZDesignSystem.Typography.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, GenZDesignSystem.Spacing.md)
                            .padding(.vertical, GenZDesignSystem.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(GenZDesignSystem.Colors.primary)
                            )
                            .genZShadow(GenZDesignSystem.Shadows.medium)
                    }
                }
                .padding(GenZDesignSystem.Spacing.md)
            }
            .cornerRadius(GenZDesignSystem.CornerRadius.lg, corners: [.topLeft, .topRight])
            
            // Content Section
            VStack(alignment: .leading, spacing: GenZDesignSystem.Spacing.md) {
                // Title and Rating Row
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(listing.title)
                            .font(GenZDesignSystem.Typography.titleLarge)
                            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(GenZDesignSystem.Colors.accentSecondary)
                            Text("\(listing.city), \(listing.state)")
                                .font(GenZDesignSystem.Typography.bodySmall)
                                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Rating with Stars
                    VStack(spacing: 2) {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(listing.rating) ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(GenZDesignSystem.Colors.warning)
                            }
                        }
                        Text(String(format: "%.1f", listing.rating))
                            .font(GenZDesignSystem.Typography.labelSmall)
                            .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    }
                }
                
                // Features with Emojis
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: GenZDesignSystem.Spacing.sm) {
                        ForEach(listing.features, id: \.id) { feature in
                            GenZFeatureChip(feature: feature)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                // Gender and Type Badges
                HStack(spacing: GenZDesignSystem.Spacing.sm) {
                    GenZGenderBadge(gender: listing.gender)
                    GenZTypeBadge(type: listing.type)
                    
                    Spacer()
                    
                    // Quick Action Button
                    Button("View Details") {
                        showDetails = true
                    }
                    .font(GenZDesignSystem.Typography.labelMedium)
                    .foregroundColor(GenZDesignSystem.Colors.primary)
                    .padding(.horizontal, GenZDesignSystem.Spacing.md)
                    .padding(.vertical, GenZDesignSystem.Spacing.xs)
                    .background(
                        Capsule()
                            .stroke(GenZDesignSystem.Colors.primary, lineWidth: 1.5)
                    )
                }
            }
            .padding(GenZDesignSystem.Spacing.lg)
        }
        .cleanCard()
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(GenZDesignSystem.Animation.smooth, value: isPressed)
        .onTapGesture {
            showDetails = true
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(listing.title), a \(listing.type.rawValue) hostel, priced at \(listing.pricePerMonth) per month, rated \(String(format: "%.1f", listing.rating)) stars.")
        .onAppear {
            animateGradient = true
        }
    }
}

// MARK: - Gen-Z Feature Chip
struct GenZFeatureChip: View {
    let feature: ListingFeatures
    
    var body: some View {
        HStack(spacing: 6) {
            Text(featureEmoji)
                .font(GenZDesignSystem.Typography.emoji)
            Text(feature.title)
                .font(GenZDesignSystem.Typography.labelSmall)
                .fontWeight(.medium)
        }
        .foregroundColor(.white)
        .padding(.horizontal, GenZDesignSystem.Spacing.md)
        .padding(.vertical, GenZDesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(featureGradient)
        )
        .genZShadow(GenZDesignSystem.Shadows.small)
    }
    
    private var featureEmoji: String {
        switch feature {
        case .verified: return "✅"
        case .mealService: return "🍽️"
        case .studyRoom: return "📚"
        case .commonArea: return "🛋️"
        case .parking: return "🅿️"
        case .rooftop: return "🌇"
        case .garden: return "🌳"
        @unknown default: return "✨"
        }
    }
    
    private var featureGradient: LinearGradient {
        switch feature {
        case .verified: return GenZDesignSystem.Colors.gradientSuccess
        case .mealService: return GenZDesignSystem.Colors.gradientWarning
        case .studyRoom: return GenZDesignSystem.Colors.gradientInfo
        case .commonArea: return GenZDesignSystem.Colors.gradientPrimary
        case .parking: return LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rooftop: return GenZDesignSystem.Colors.gradientAccent
        case .garden: return GenZDesignSystem.Colors.gradientSuccess
        @unknown default: return GenZDesignSystem.Colors.gradientPrimary
        }
    }
}

// MARK: - Gen-Z Gender Badge
struct GenZGenderBadge: View {
    let gender: Gender
    
    var body: some View {
        HStack(spacing: 4) {
            Text(genderEmoji)
                .font(.system(size: 14))
            Text(gender.description)
                .font(GenZDesignSystem.Typography.labelSmall)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, GenZDesignSystem.Spacing.md)
        .padding(.vertical, GenZDesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(genderGradient)
        )
    }
    
    private var genderEmoji: String {
        switch gender {
        case .male: return "👨"
        case .female: return "👩"
        case .coed: return "👫"
        }
    }
    
    private var genderGradient: LinearGradient {
        switch gender {
        case .male:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
        case .female:
            return LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing)
        case .coed:
            return LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
        }
    }
}

// MARK: - Gen-Z Type Badge
struct GenZTypeBadge: View {
    let type: ListingType
    
    var body: some View {
        HStack(spacing: 4) {
            Text(typeEmoji)
                .font(.system(size: 16))
            Text(type.description)
                .font(GenZDesignSystem.Typography.labelSmall)
                .fontWeight(.medium)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
        }
        .padding(.horizontal, GenZDesignSystem.Spacing.md)
        .padding(.vertical, GenZDesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(GenZDesignSystem.Colors.primary.opacity(0.1))
        )
        .overlay(
            Capsule()
                .stroke(GenZDesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var typeEmoji: String {
        switch type {
        case .hostel: return "🏠"
        case .pg: return "🏢"
        case .coliving: return "🏘️"
        }
    }
}

// MARK: - Gen-Z Search Bar
struct GenZSearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    @State private var pulseAnimation = false
    
    var body: some View {
        HStack(spacing: GenZDesignSystem.Spacing.md) {
            HStack(spacing: GenZDesignSystem.Spacing.md) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(
                        isEditing ? GenZDesignSystem.Colors.primary : GenZDesignSystem.Colors.textTertiary
                    )
                    .font(.system(size: 18, weight: .medium))
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(
                        GenZDesignSystem.Animation.bouncy.repeatForever(autoreverses: true),
                        value: pulseAnimation
                    )
                
                TextField("Find your perfect hostel... 🏠", text: $searchText)
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                    .onTapGesture {
                        withAnimation(GenZDesignSystem.Animation.smooth) {
                            isEditing = true
                            pulseAnimation = true
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation(GenZDesignSystem.Animation.quick) {
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                            .stroke(
                                isEditing ? 
                                GenZDesignSystem.Colors.primary :
                                GenZDesignSystem.Colors.textTertiary.opacity(0.3),
                                lineWidth: isEditing ? 2 : 1
                            )
                    )
                    .genZShadow(GenZDesignSystem.Shadows.small)
            )      
            if isEditing {
                Button("Cancel") {
                    withAnimation(GenZDesignSystem.Animation.smooth) {
                        isEditing = false
                        pulseAnimation = false
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .font(GenZDesignSystem.Typography.labelLarge)
                .foregroundColor(GenZDesignSystem.Colors.primary)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(GenZDesignSystem.Animation.smooth, value: isEditing)
    }
}

// MARK: - Gen-Z Floating Action Button
struct GenZFloatingActionButton: View {
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    @State private var isPressed = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(gradient)
                        .genZShadow(GenZDesignSystem.Shadows.medium)
                )
                .rotationEffect(.degrees(rotationAngle))
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(GenZDesignSystem.Animation.bouncy, value: isPressed)
        .onLongPressGesture(minimumDuration: 0.1) { pressing in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

// MARK: - Gen-Z Filter Pill
struct GenZFilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(GenZDesignSystem.Typography.labelLarge)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : GenZDesignSystem.Colors.textPrimary)
                .padding(.horizontal, GenZDesignSystem.Spacing.lg)
                .padding(.vertical, GenZDesignSystem.Spacing.sm)
                .background(
                    Capsule()
                        .fill(
                            isSelected ? 
                            GenZDesignSystem.Colors.primary :
                            GenZDesignSystem.Colors.surface
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected ? Color.clear : GenZDesignSystem.Colors.primary.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                        .genZShadow(GenZDesignSystem.Shadows.small)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(GenZDesignSystem.Animation.bouncy, value: isPressed)
        .animation(GenZDesignSystem.Animation.smooth, value: isSelected)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

// GenZTabBar is now implemented in its own dedicated file: GenZTabBar.swift

// CornerRadius helpers are defined in FuturisticComponents.swift to avoid duplication.
