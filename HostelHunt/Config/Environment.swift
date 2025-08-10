import Foundation

enum AppEnvironment {
    case development
    case staging
    case production
    
    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct EnvironmentConfig {
    static let shared = EnvironmentConfig()
    
    private init() {}
    
    var supabaseURL: String {
        switch AppEnvironment.current {
        case .development:
            return getConfigValue(for: "SUPABASE_URL_DEV") ?? "https://ejkgiqscfziroetzkgvj.supabase.co"
        case .staging:
            return getConfigValue(for: "SUPABASE_URL_STAGING") ?? "https://ejkgiqscfziroetzkgvj.supabase.co"
        case .production:
            return getConfigValue(for: "SUPABASE_URL_PROD") ?? "https://ejkgiqscfziroetzkgvj.supabase.co"
        }
    }
    
    var supabaseKey: String {
        switch AppEnvironment.current {
        case .development:
            return getConfigValue(for: "SUPABASE_KEY_DEV") ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqa2dpcXNjZnppcm9ldHprZ3ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTA1NzYsImV4cCI6MjA3MDA2NjU3Nn0.2YSKMjwFLcfuE5L6cBiUdRWBvoOrg8kvapvkFqCkjmE"
        case .staging:
            return getConfigValue(for: "SUPABASE_KEY_STAGING") ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqa2dpcXNjZnppcm9ldHprZ3ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTA1NzYsImV4cCI6MjA3MDA2NjU3Nn0.2YSKMjwFLcfuE5L6cBiUdRWBvoOrg8kvapvkFqCkjmE"
        case .production:
            return getConfigValue(for: "SUPABASE_KEY_PROD") ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqa2dpcXNjZnppcm9ldHprZ3ZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTA1NzYsImV4cCI6MjA3MDA2NjU3Nn0.2YSKMjwFLcfuE5L6cBiUdRWBvoOrg8kvapvkFqCkjmE"
        }
    }
    
    var analyticsKey: String? {
        return getConfigValue(for: "ANALYTICS_KEY")
    }
    
    var pushNotificationKey: String? {
        return getConfigValue(for: "PUSH_NOTIFICATION_KEY")
    }
    
    private func getConfigValue(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}

// MARK: - Feature Flags
extension EnvironmentConfig {
    var isAnalyticsEnabled: Bool {
        return AppEnvironment.current != .development
    }
    
    var isPushNotificationsEnabled: Bool {
        return true
    }
    
    var isAIRecommendationsEnabled: Bool {
        return AppEnvironment.current == .production
    }
    
    var isDebugModeEnabled: Bool {
        return AppEnvironment.current == .development
    }
}
