import SwiftUI

// MARK: - Modern Design System
struct ModernDesignSystem {
    
    // MARK: - Color Palette
    struct Colors {
        static let primary = Color(hex: "#4B5945")
        static let secondary = Color(hex: "#66785F")
        static let accent1 = Color(hex: "#91AC8F")
        static let accent2 = Color(hex: "#B2C9AD")
        
        static let text = primary
        static let textSecondary = secondary
        static let backgroundGradient = LinearGradient(gradient: Gradient(colors: [accent2, accent1.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
        static let solidBackground = accent2
        static let cardBackground = secondary.opacity(0.2)
        
        static let heroGradient = LinearGradient(
            gradient: Gradient(colors: [primary, secondary]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Typography
    struct Typography {
        static let fontName = "Inter"
        
        static let body = Font.custom(fontName, size: 16)
        static let button = Font.custom(fontName, size: 18).weight(.semibold)
    }
    
    // MARK: - Sizing and Spacing
    struct Sizing {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 16
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let subtle = ModernShadow(color: ModernDesignSystem.Colors.primary.opacity(0.2), radius: 5, x: 0, y: 2)
        static let lift = ModernShadow(color: ModernDesignSystem.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
        static let glow = ModernShadow(color: ModernDesignSystem.Colors.primary.opacity(0.5), radius: 10, x: 0, y: 0)
    }
}

// MARK: - Shadow Helper
struct ModernShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers
extension View {
    func modernCard() -> some View {
        self
            .padding()
            .background(ModernDesignSystem.Colors.cardBackground)
            .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
            .shadow(color: ModernDesignSystem.Colors.primary.opacity(0.2), radius: 5, x: 0, y: 2)
    }

    func modernTextField(isFocused: Bool) -> some View {
        self
            .padding(ModernDesignSystem.Sizing.padding)
            .background(ModernDesignSystem.Colors.cardBackground)
            .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: ModernDesignSystem.Sizing.cornerRadius)
                    .stroke(isFocused ? ModernDesignSystem.Colors.primary : ModernDesignSystem.Colors.secondary.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: isFocused ? ModernDesignSystem.Colors.primary.opacity(0.3) : .clear, radius: 5, x: 0, y: 0)
    }
    
    func modernButton() -> some View {
        self
            .padding()
            .background(ModernDesignSystem.Colors.heroGradient)
            .foregroundColor(ModernDesignSystem.Colors.accent2)
            .font(ModernDesignSystem.Typography.button)
            .cornerRadius(ModernDesignSystem.Sizing.cornerRadius)
            .shadow(color: ModernDesignSystem.Colors.primary.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
