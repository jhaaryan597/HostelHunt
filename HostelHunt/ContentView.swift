import SwiftUI

struct ContentView: View {
    @StateObject var authService = AuthService.shared

    var body: some View {
        MainTabView()
            .environmentObject(authService)
    }
}

#Preview {
    ContentView()
}
