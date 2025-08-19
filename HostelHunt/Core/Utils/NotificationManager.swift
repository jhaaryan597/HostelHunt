import SwiftUI
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    @Published var deviceToken: String?
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// Requests authorization to send notifications and registers for remote notifications if granted.
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    /// Handles successful registration for remote notifications.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Successfully registered for notifications with device token: \(tokenString)")
        DispatchQueue.main.async {
            self.deviceToken = tokenString
            Task {
                await SupabaseManager.shared.updateDeviceToken(tokenString)
            }
        }
    }
    
    /// Handles failed registration for remote notifications.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    /// Handles incoming notifications while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show alert, sound, and update badge for foreground notifications
        completionHandler([.banner, .sound, .badge])
    }
}
