import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    init() {
        let config = EnvironmentConfig.shared
        guard let supabaseURL = URL(string: config.supabaseURL) else {
            fatalError("Invalid Supabase URL configuration")
        }
        
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: config.supabaseKey)
    }
    
    func updateDeviceToken(_ token: String) async {
        do {
            let currentUser = try await client.auth.user()
            let updates = ["device_token": token]
            
            try await client.from("users").update(updates).eq("id", value: currentUser.id).execute()
            print("Successfully updated device token")
        } catch {
            print("Error updating device token: \(error)")
        }
    }
}
