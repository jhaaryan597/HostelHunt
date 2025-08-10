import SwiftUI

struct GenZAuthTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: GenZDesignSystem.Spacing.md) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(isFocused ? GenZDesignSystem.Colors.gradientAccent : LinearGradient(colors: [GenZDesignSystem.Colors.textSecondary], startPoint: .top, endPoint: .bottom))
                .frame(width: 30)

            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(GenZDesignSystem.Colors.textTertiary)
                    .font(GenZDesignSystem.Typography.body)
            }
            .font(GenZDesignSystem.Typography.body)
            .foregroundColor(GenZDesignSystem.Colors.textPrimary)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($isFocused)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                .fill(GenZDesignSystem.Colors.glassPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.lg)
                        .stroke(isFocused ? GenZDesignSystem.Colors.primary : Color.gray.opacity(0.3), lineWidth: isFocused ? 2 : 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .animation(GenZDesignSystem.Animation.bouncy, value: isFocused)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
