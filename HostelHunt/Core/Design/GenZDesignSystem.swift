import SwiftUI

// MARK: - Clean Gen-Z Design System
struct GenZDesignSystem {
    
    // MARK: - Refined Color Palette
    struct Colors {
        // Primary Brand Colors - Clean and Modern
        static let primary = Color(red: 0.2, green: 0.4, blue: 1.0) // Clean Blue
        static let primaryLight = Color(red: 0.4, green: 0.6, blue: 1.0) // Light Blue
        static let primaryDark = Color(red: 0.1, green: 0.2, blue: 0.8) // Deep Blue
        
        // Accent Colors - Refined and Balanced
        static let accent = Color(red: 0.9, green: 0.3, blue: 0.6) // Modern Pink
        static let accentLight = Color(red: 0.95, green: 0.6, blue: 0.8) // Soft Pink
        static let accentSecondary = Color(red: 0.6, green: 0.4, blue: 0.9) // Clean Purple
        
        // Supporting Colors - Carefully Selected
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4) // Clean Green
        static let warning = Color(red: 1.0, green: 0.7, blue: 0.2) // Warm Orange
        static let error = Color(red: 1.0, green: 0.3, blue: 0.3) // Clean Red
        static let info = Color(red: 0.3, green: 0.7, blue: 1.0) // Info Blue
        
        // Clean Backgrounds - Subtle and Elegant
        static let background = Color(red: 0.98, green: 0.98, blue: 1.0) // Clean White with Blue Tint
        static let backgroundSecondary = Color(red: 0.95, green: 0.96, blue: 0.98) // Light Gray-Blue
        static let surface = Color.white
        static let surfaceSecondary = Color(red: 0.97, green: 0.97, blue: 0.99)
        static let surfaceElevated = Color.white
        
        // Text Colors - High Contrast and Readable
        static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.2) // Dark Blue-Gray
        static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.5) // Medium Gray
        static let textTertiary = Color(red: 0.6, green: 0.6, blue: 0.7) // Light Gray
        static let textInverse = Color.white
        
        // Glass Effects - Subtle and Clean
        static let glassPrimary = Color.white.opacity(0.1)
        static let glassSecondary = Color.white.opacity(0.05)
        static let glassDark = Color.black.opacity(0.1)
        
        // Clean Gradients - Subtle and Professional
        static let gradientPrimary = LinearGradient(
            colors: [primary, primaryLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let gradientAccent = LinearGradient(
            colors: [accent, accentLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let gradientBackground = LinearGradient(
            colors: [background, backgroundSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let gradientSuccess = LinearGradient(
            colors: [success, success.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let gradientWarning = LinearGradient(
            colors: [warning, warning.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let gradientError = LinearGradient(
            colors: [error, error.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let gradientInfo = LinearGradient(
            colors: [info, info.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        

        

    }
    
    // MARK: - Typography - Gen-Z Friendly
    struct Typography {
        // Display - Bold and Impactful
        static let displayLarge = Font.custom("SF Pro Display", size: 64).weight(.black)
        static let displayMedium = Font.custom("SF Pro Display", size: 48).weight(.black)
        static let displaySmall = Font.custom("SF Pro Display", size: 36).weight(.bold)
        
        // Headlines - Attention Grabbing
        static let headlineLarge = Font.custom("SF Pro Display", size: 32).weight(.heavy)
        static let headlineMedium = Font.custom("SF Pro Display", size: 28).weight(.bold)
        static let headlineSmall = Font.custom("SF Pro Display", size: 24).weight(.bold)
        
        // Titles - Clean and Modern
        static let titleLarge = Font.custom("SF Pro Text", size: 22).weight(.semibold)
        static let titleMedium = Font.custom("SF Pro Text", size: 18).weight(.semibold)
        static let title1 = Font.custom("SF Pro Display", size: 34).weight(.bold)
        static let title2 = Font.custom("SF Pro Display", size: 28).weight(.bold)
        static let title3 = Font.custom("SF Pro Display", size: 22).weight(.bold)
        
        // Body - Readable and Friendly
        static let body = Font.custom("SF Pro Text", size: 17).weight(.regular)
        static let bodyRegular = Font.custom("SF Pro Text", size: 17).weight(.regular)
        static let bodyLarge = Font.custom("SF Pro Text", size: 17).weight(.regular)
        static let bodySmall = Font.custom("SF Pro Text", size: 13).weight(.regular)
        static let subheadline = Font.custom("SF Pro Text", size: 15).weight(.semibold)
        
        // Labels - Subtle but Clear
        static let labelLarge = Font.custom("SF Pro Text", size: 15).weight(.medium)
        static let labelMedium = Font.custom("SF Pro Text", size: 13).weight(.medium)
        static let labelSmall = Font.custom("SF Pro Text", size: 11).weight(.medium)
        
        // Special - For Emphasis
        static let emoji = Font.system(size: 24)
        static let price = Font.custom("SF Pro Display", size: 28).weight(.black)
        static let caption = Font.custom("SF Pro Text", size: 12).weight(.regular)
    }
    
    // MARK: - Spacing - Generous and Breathable
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
        static let mega: CGFloat = 96
    }
    
    // MARK: - Corner Radius - Rounded and Friendly
    struct CornerRadius {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 36
        static let round: CGFloat = 50
        static let pill: CGFloat = 100
    }
    
    // MARK: - Shadows - Depth and Elevation
    struct Shadows {
        static let subtle = GenZShadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
        static let small = GenZShadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
        static let medium = GenZShadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        static let large = GenZShadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        static let extraLarge = GenZShadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)

    }

    // MARK: - Animations - Smooth and Engaging
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.15)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.25)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.9)
        static let elastic = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.7)
        static let playful = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.4)
    }

    // MARK: - Icon Sizes
    struct IconSize {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
}

// MARK: - Gen-Z View Extensions
extension View {
    // MARK: - Shadow Effects
    func genZShadow(_ shadow: GenZShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    

    
    // MARK: - Glass Morphism
    func glassCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.glassPrimary)
                    .background(
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .backdrop(blur: 20)
            )
    }
    
    // MARK: - Clean Glass Effect
    func cleanGlass() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.glassPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
    
    func ultraGlassCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                    .fill(GenZDesignSystem.Colors.glassPrimary)
                    .background(
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .backdrop(blur: 30)
            )
    }
    
    // MARK: - Clean Card Styles
    func cleanCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.surface)
            )
            .genZShadow(GenZDesignSystem.Shadows.small)
    }
    
    func elevatedCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.surfaceElevated)
            )
            .genZShadow(GenZDesignSystem.Shadows.medium)
    }
    
    // MARK: - Clean Button Styles
    func primaryButton() -> some View {
        self
            .padding(.horizontal, GenZDesignSystem.Spacing.xl)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .background(GenZDesignSystem.Colors.primary)
            .foregroundColor(.white)
            .font(GenZDesignSystem.Typography.labelLarge)
            .cornerRadius(GenZDesignSystem.CornerRadius.lg)
            .genZShadow(GenZDesignSystem.Shadows.small)
    }
    
    func accentButton() -> some View {
        self
            .padding(.horizontal, GenZDesignSystem.Spacing.xl)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .background(GenZDesignSystem.Colors.accent)
            .foregroundColor(.white)
            .font(GenZDesignSystem.Typography.labelLarge)
            .cornerRadius(GenZDesignSystem.CornerRadius.lg)
            .genZShadow(GenZDesignSystem.Shadows.small)
    }
    
    func ghostButton() -> some View {
        self
            .padding(.horizontal, GenZDesignSystem.Spacing.xl)
            .padding(.vertical, GenZDesignSystem.Spacing.md)
            .background(Color.clear)
            .foregroundColor(GenZDesignSystem.Colors.primary)
            .font(GenZDesignSystem.Typography.labelLarge)
            .cornerRadius(GenZDesignSystem.CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .stroke(GenZDesignSystem.Colors.primary, lineWidth: 1)
            )
    }
    
    // MARK: - Clean Interactive Effects
    func pressAnimation() -> some View {
        self
            .scaleEffect(1.0)
            .animation(GenZDesignSystem.Animation.quick, value: UUID())
    }
    
}

// MARK: - GenZ Shadow Helper
struct GenZShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
