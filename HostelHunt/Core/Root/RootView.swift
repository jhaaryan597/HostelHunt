import SwiftUI

struct RootView: View {
    @StateObject var authService = AuthService.shared

    var body: some View {
        Group {
            MainTabView()
        }
        .environmentObject(authService)
    }
}