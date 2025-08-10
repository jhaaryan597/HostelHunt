import SwiftUI

struct ContentView: View {
    @StateObject var authService = AuthService.shared

    var body: some View {
        GenZMainContentView()
            .environmentObject(authService)
    }
}

#Preview {
    ContentView()
}
