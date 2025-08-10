import SwiftUI
import Supabase

@main
struct HostelHuntApp: App {
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(.black).ignoresSafeArea()
                MainTabView()
                    .environmentObject(authService)
                    .tint(Color("AccentColor"))
            }
            .onAppear {
                NotificationManager.shared.requestAuthorization()
            }
            .onOpenURL { url in
                Task {
                    do {
                        _ = try await SupabaseManager.shared.client.auth.session(from: url)
                    } catch {
                        print("Error handling deep link: \(error)")
                    }
                }
            }
        }
    }
}
