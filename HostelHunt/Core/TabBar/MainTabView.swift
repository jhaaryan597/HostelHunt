import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GenZExploreView()
                .tabItem { Label("Explore", systemImage: "magnifyingglass") }
            
            CommunityView()
                .tabItem { Label("Community", systemImage: "person.2") }
            
            WishlistsView()
                .tabItem { Label("Wishlists", systemImage: "heart") }
            
            NavigationView {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .dark)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .tint(GenZDesignSystem.Colors.primary)
    }
}


#Preview {
    MainTabView()
}
