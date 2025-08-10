import SwiftUI

// MARK: - Gen-Z Tab Bar
struct GenZTabBar: View {
    @Binding var selectedTab: Int
    @State private var animateSelection = false
    @Namespace private var namespace
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Explore", index: 0),
        TabItem(icon: "magnifyingglass", title: "Search", index: 1),
        TabItem(icon: "heart.fill", title: "Wishlist", index: 2),
        TabItem(icon: "message.fill", title: "Messages", index: 3),
        TabItem(icon: "person.fill", title: "Profile", index: 4)
    ]
    
    var body: some View {
        tabBarButtons
            .padding(.horizontal, GenZDesignSystem.Spacing.md)
            .padding(.vertical, GenZDesignSystem.Spacing.lg)
            .background(tabBarBackground)
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .padding(.bottom, GenZDesignSystem.Spacing.md)
    }

    private var tabBarButtons: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                GenZTabButton(
                    namespace: namespace,
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    animateSelection: animateSelection
                ) {
                    withAnimation(GenZDesignSystem.Animation.bouncy) {
                        selectedTab = tab.index
                        animateSelection.toggle()
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var tabBarBackground: some View {
        ZStack {
            // Material background for the glass effect
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                .fill(.ultraThinMaterial)

            // Gradient fill
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                .fill(GenZDesignSystem.Colors.surface.opacity(0.8))

            // Gradient stroke
            RoundedRectangle(cornerRadius: GenZDesignSystem.CornerRadius.xl)
                .stroke(
                    LinearGradient(
                        colors: [GenZDesignSystem.Colors.primary.opacity(0.5), GenZDesignSystem.Colors.accent.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
        .genZShadow(GenZDesignSystem.Shadows.large)
    }
}

// MARK: - Tab Item Model
struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

// MARK: - Gen-Z Tab Button
struct GenZTabButton: View {
    let namespace: Namespace.ID
    let tab: TabItem
    let isSelected: Bool
    let animateSelection: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: GenZDesignSystem.Spacing.sm) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                
                if isSelected {
                    Text(tab.title)
                        .font(GenZDesignSystem.Typography.labelMedium)
                        .fontWeight(.bold)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                }
            }
            .foregroundColor(isSelected ? .white : GenZDesignSystem.Colors.textSecondary)
            .padding(.horizontal, GenZDesignSystem.Spacing.lg)
            .frame(height: 44)
            .background(
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(GenZDesignSystem.Colors.primary.opacity(0.8))
                            .matchedGeometryEffect(id: "selected_tab_background", in: namespace)
                            .genZShadow(GenZDesignSystem.Shadows.medium)
                    }
                }
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(GenZDesignSystem.Animation.bouncy, value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
        .onChange(of: isSelected) { selected in
            if selected {
                pulseAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    pulseAnimation = false
                }
            }
        }
    }
}

// MARK: - Main Content View with Gen-Z Tab Bar
struct GenZMainContentView: View {
    @State private var selectedTab = 0
    @StateObject private var authService = AuthService()
    
    var body: some View {
        ZStack {
            // Background
            GenZDesignSystem.Colors.gradientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        GenZExploreView()
                    case 1:
                        GenZSearchView()
                    case 2:
                        WishlistsView()
                    case 3:
                        GenZMessagesView()
                    case 4:
                        ProfileView()
                    default:
                        GenZExploreView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                
                // Custom Tab Bar
                GenZTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(authService)
    }
}

// MARK: - Placeholder Views for Other Tabs
struct GenZSearchView: View {
    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.background.ignoresSafeArea()
            VStack(spacing: GenZDesignSystem.Spacing.lg) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.system(size: 80))
                    .foregroundStyle(GenZDesignSystem.Colors.gradientPrimary)
                    
                
                Text("Search Under Construction")
                    .font(GenZDesignSystem.Typography.title2)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("Our advanced search is getting a glow-up. Stay tuned!")
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}



struct GenZMessagesView: View {
    var body: some View {
        ZStack {
            GenZDesignSystem.Colors.background.ignoresSafeArea()
            VStack(spacing: GenZDesignSystem.Spacing.lg) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(GenZDesignSystem.Colors.gradientAccent)
                    
                
                Text("Inbox Coming Soon")
                    .font(GenZDesignSystem.Typography.title2)
                    .foregroundColor(GenZDesignSystem.Colors.textPrimary)
                
                Text("Soon you'll be able to connect with hosts and fellow travelers.")
                    .font(GenZDesignSystem.Typography.body)
                    .foregroundColor(GenZDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Preview
struct GenZTabBar_Previews: PreviewProvider {
    static var previews: some View {
        GenZMainContentView()
            .preferredColorScheme(.dark)
    }
}
