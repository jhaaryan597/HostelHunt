import SwiftUI

// MARK: - Futuristic Button Styles
struct FuturisticPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(GenZDesignSystem.Typography.labelLarge)
            .foregroundColor(GenZDesignSystem.Colors.textInverse)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.gradientPrimary)
                    .shadow(color: GenZDesignSystem.Colors.primary.opacity(0.5), radius: 10, x: 0, y: 10)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(GenZDesignSystem.Animation.bouncy, value: configuration.isPressed)
    }
}

struct FuturisticAccentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(GenZDesignSystem.Typography.labelLarge)
            .foregroundColor(GenZDesignSystem.Colors.textInverse)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                    .fill(GenZDesignSystem.Colors.gradientAccent)
                    .shadow(color: GenZDesignSystem.Colors.accent.opacity(0.5), radius: 10, x: 0, y: 10)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(GenZDesignSystem.Animation.bouncy, value: configuration.isPressed)
    }
}

// MARK: - Futuristic Card View
struct FuturisticCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                    .fill(GenZDesignSystem.Colors.glassPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                            .stroke(GenZDesignSystem.Colors.primary.opacity(0.5), lineWidth: 2)
                    )
                    .background(GenZDesignSystem.Colors.auroraBackground)
                    .clipped()
            )
            .cornerRadius(GenZDesignSystem.CornerRadius.xl)
    }
}

// MARK: - Futuristic Text Field
struct FuturisticTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
            TextField(placeholder, text: $text)
                .font(GenZDesignSystem.Typography.body)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                .fill(GenZDesignSystem.Colors.glassSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                        .stroke(GenZDesignSystem.Colors.primary.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

// MARK: - Futuristic Profile Detail Row
struct FuturisticProfileDetailRow: View {
    let iconName: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                .frame(width: 40)
            
            Text(label)
                .font(GenZDesignSystem.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(GenZDesignSystem.Typography.body)
                .foregroundColor(GenZDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(GenZDesignSystem.Colors.glassPrimary)
        .cornerRadius(GenZDesignSystem.CornerRadius.lg)
    }
}
