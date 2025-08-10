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
}
