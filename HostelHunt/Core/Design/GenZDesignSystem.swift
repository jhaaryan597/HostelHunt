import SwiftUI

// MARK: - Futuristic Gen-Z Design System
struct GenZDesignSystem {
    
    // MARK: - Futuristic Color Palette
    struct Colors {
        // Core Brand Colors - Vibrant and Energetic
        static let primary = Color(hex: "#00FFFF") // Electric Blue
        static let primaryLight = Color(hex: "#7B68EE") // Medium Slate Blue
        static let primaryDark = Color(hex: "#00008B") // Dark Blue
        
        // Accent Colors - Bold and Eye-Catching
        static let accent = Color(hex: "#FF00FF") // Magenta
        static let accentLight = Color(hex: "#FF7F50") // Coral
        static let accentSecondary = Color(hex: "#EE82EE") // Violet
        
        // Supporting Colors - Functional and Clear
        static let success = Color(hex: "#39FF14") // Neon Green
        static let warning = Color(hex: "#FFFF00") // Electric Yellow
        static let error = Color(hex: "#FF3131") // Fiery Red
        static let info = Color(hex: "#1E90FF") // Dodger Blue
        
        // Futuristic Backgrounds - Deep and Immersive
        static let background = Color(hex: "#0D0D0D") // Near Black
        static let backgroundSecondary = Color(hex: "#1A1A1A") // Dark Gray
        static let surface = Color(hex: "#1F1F1F") // Slightly Lighter Gray
        static let surfaceSecondary = Color(hex: "#2A2A2A") // Medium Gray
        static let surfaceElevated = Color(hex: "#333333") // Light Gray
        
        // Text Colors - High Contrast and Legible
        static let textPrimary = Color.white
        static let textSecondary = Color.gray
        static let textTertiary = Color(hex: "#A9A9A9") // Dark Gray
        static let textInverse = Color.black
        
        // Glassmorphism Effects - Transparent and Layered
        static let glassPrimary = Color.white.opacity(0.1)
        static let glassSecondary = Color.white.opacity(0.05)
        static let glassDark = Color.black.opacity(0.2)
        
        // Dynamic Gradients - Fluid and Eye-Catching
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
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let auroraBackground = LinearGradient(
            colors: [primary.opacity(0.3), accent.opacity(0.3), background],
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
