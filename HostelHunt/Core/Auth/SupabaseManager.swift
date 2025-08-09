import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    init() {
        let supabaseURL = URL(string: "https://ejkgiqscfziroetzkgvj.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqa2dpcXNjZnppcm9ldHprZ3ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTA1NzYsImV4cCI6MjA3MDA2NjU3Nn0.2YSKMjwFLcfuE5L6cBiUdRWBvoOrg8kvapvkFqCkjmE"

        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
}
