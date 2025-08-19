import Foundation

@MainActor
class ReservationService: ObservableObject {
    func reserve(listing: Listing, user: User) async throws {
        // Simulate a network call
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // In a real app, you would make a network request to your backend
        // to create the reservation. For now, we'll just print a confirmation.
        print("Successfully reserved \(listing.title) for \(user.fullname)")
    }
}
