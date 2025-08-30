import Foundation
import Supabase

@MainActor
class ReservationService: ObservableObject {
    private let supabase = SupabaseManager.shared.client

    func createReservation(_ reservation: Reservation) async throws {
        let response = try await supabase.database
            .from("reservations")
            .insert(reservation)
            .execute()

        if response.status != 201 {
            throw NSError(domain: "ReservationService", code: response.status, userInfo: [NSLocalizedDescriptionKey: "Failed to create reservation"])
        }
    }
    
    func reserve(listing: Listing, user: User, startDate: Date, endDate: Date) async throws {
        let totalPrice = calculateTotalPrice(listing: listing, startDate: startDate, endDate: endDate)
        let finalPrice = totalPrice * 1.18 // Add 18% GST
        
        let reservation = Reservation(
            id: UUID().uuidString,
            listingId: listing.id,
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
            totalPrice: Int(finalPrice)
        )
        
        try await createReservation(reservation)
        
        // Award "First Booking" reward
        let rewards = try await RewardService.shared.fetchRewards()
        if let firstBookingReward = rewards.first(where: { $0.name == "First Booking" }) {
            if let userId = UUID(uuidString: user.id) {
                let userRewards = try await RewardService.shared.fetchUserRewards(for: userId)
                if userRewards.isEmpty {
                    try await RewardService.shared.awardReward(firstBookingReward, for: userId)
                }
            }
        }
    }
    
    func calculateTotalPrice(listing: Listing, startDate: Date, endDate: Date) -> Double {
        let calendar = Calendar.current
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let pricePerDay = Double(listing.pricePerMonth) / 30.0
        return pricePerDay * Double(numberOfDays)
    }
}
