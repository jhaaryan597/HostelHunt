import SwiftUI

struct RootView: View {
    @StateObject var authService = AuthService.shared

    var body: some View {
        Group {
            if authService.user == nil {
                NavigationView {
                    LoginView()
                }
            } else {
                MainTabView()
            }
        }
        .environmentObject(authService)
    }
}
