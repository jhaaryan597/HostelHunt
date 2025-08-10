import SwiftUI
import Combine

// MARK: - Listing Service
@MainActor
class ListingService: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var isLoading = false
    
    private let supabaseManager = SupabaseManager.shared
    
    init() {
        // Initialize service
    }
    
    // MARK: - Fetch Listings
    func fetchListings() async throws -> [Listing] {
        isLoading = true
        defer { isLoading = false }
        
        // In a real app, this would fetch from Supabase
        // For now, return mock data
        return generateMockListings()
    }
    
    // MARK: - Search Listings
    func searchListings(query: String, filters: SearchFilters) async throws -> [Listing] {
        // Simulate API call with delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock search results - in real app, this would call Supabase
        let mockListings = generateMockListings()
        
        return mockListings.filter { listing in
            // Text search
            let matchesQuery = query.isEmpty ||
                listing.title.localizedCaseInsensitiveContains(query) ||
                listing.address.localizedCaseInsensitiveContains(query) ||
                listing.ownerName.localizedCaseInsensitiveContains(query)
            
            // Price filter
            let matchesPrice = filters.priceRange.contains(listing.pricePerMonth)
            
            // Gender filter
            let matchesGender = filters.gender == nil || listing.gender == filters.gender
            
            // Type filter
            let matchesType = filters.type == nil || listing.type == filters.type
            
            // Amenities filter
            let matchesAmenities = filters.amenities.isEmpty ||
                filters.amenities.isSubset(of: Set(listing.amenities))
            
            // Features filter
            let matchesFeatures = filters.features.isEmpty ||
                filters.features.isSubset(of: Set(listing.features))
            
            // Rating filter
            let matchesRating = listing.rating >= filters.rating
            
            return matchesQuery && matchesPrice && matchesGender &&
                   matchesType && matchesAmenities && matchesFeatures && matchesRating
        }
    }
    
    // MARK: - Mock Data Generation
    private func generateMockListings() -> [Listing] {
        return [
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner1",
                ownerName: "Priya Sharma",
                ownerImageUrl: "female-profile-photo1",
                numberOfBeds: 2,
                pricePerMonth: 7500,
                latitude: 28.6139,
                longitude: 77.2090,
                imageURLs: ["hostel1.jpg"],
                address: "North Campus",
                city: "Delhi",
                state: "Delhi",
                title: "Cozy Girls Hostel Near DU",
                rating: 4.5,
                features: [.verified, .mealService],
                amenities: [.wifi, .laundry, .security, .studyRoom],
                type: .hostel,
                gender: .female,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner2",
                ownerName: "Rajesh Kumar",
                ownerImageUrl: "male-profile-photo1",
                numberOfBeds: 1,
                pricePerMonth: 12000,
                latitude: 28.5355,
                longitude: 77.3910,
                imageURLs: ["pg1.jpg"],
                address: "Sector 18",
                city: "Noida",
                state: "Uttar Pradesh",
                title: "Premium PG with AC",
                rating: 4.8,
                features: [.verified, .mealService],
                amenities: [.wifi, .ac, .laundry, .security],
                type: .pg,
                gender: .coed,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner3",
                ownerName: "Anita Gupta",
                ownerImageUrl: "female-profile-photo2",
                numberOfBeds: 4,
                pricePerMonth: 5500,
                latitude: 28.7041,
                longitude: 77.1025,
                imageURLs: ["hostel2.jpg"],
                address: "GTB Nagar",
                city: "Delhi",
                state: "Delhi",
                title: "Budget Friendly Boys Hostel",
                rating: 4.0,
                features: [.verified],
                amenities: [.wifi, .laundry, .security],
                type: .hostel,
                gender: .male,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner4",
                ownerName: "Suresh Patel",
                ownerImageUrl: "male-profile-photo2",
                numberOfBeds: 1,
                pricePerMonth: 15000,
                latitude: 28.4595,
                longitude: 77.0266,
                imageURLs: ["coliving1.jpg"],
                address: "Cyber City",
                city: "Gurgaon",
                state: "Haryana",
                title: "Modern Co-living Space",
                rating: 4.9,
                features: [.verified, .mealService],
                amenities: [.wifi, .ac, .laundry, .security, .parking],
                type: .pg,
                gender: .coed,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner5",
                ownerName: "Meera Singh",
                ownerImageUrl: "female-profile-photo3",
                numberOfBeds: 2,
                pricePerMonth: 9000,
                latitude: 28.6692,
                longitude: 77.4538,
                imageURLs: ["pg2.jpg"],
                address: "Laxmi Nagar",
                city: "Delhi",
                state: "Delhi",
                title: "Girls Only PG Near Metro",
                rating: 4.3,
                features: [.verified, .mealService],
                amenities: [.wifi, .laundry, .security, .studyRoom],
                type: .pg,
                gender: .female,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner6",
                ownerName: "Arjun Mehta",
                ownerImageUrl: "male-profile-photo3",
                numberOfBeds: 1,
                pricePerMonth: 11000,
                latitude: 28.4089,
                longitude: 77.3178,
                imageURLs: ["pg3.jpg"],
                address: "Hauz Khas",
                city: "New Delhi",
                state: "Delhi",
                title: "Executive PG for Professionals",
                rating: 4.6,
                features: [.verified, .mealService],
                amenities: [.wifi, .ac, .laundry, .security, .parking],
                type: .pg,
                gender: .male,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner7",
                ownerName: "Kavya Reddy",
                ownerImageUrl: "female-profile-photo4",
                numberOfBeds: 3,
                pricePerMonth: 8500,
                latitude: 28.6304,
                longitude: 77.2177,
                imageURLs: ["hostel3.jpg"],
                address: "Karol Bagh",
                city: "New Delhi",
                state: "Delhi",
                title: "Safe Haven Girls Hostel",
                rating: 4.7,
                features: [.verified, .mealService],
                amenities: [.wifi, .laundry, .security, .ac, .studyRoom],
                type: .hostel,
                gender: .female,
                reviews: []
            ),
            Listing(
                id: UUID().uuidString,
                ownerUid: "owner8",
                ownerName: "Vikram Singh",
                ownerImageUrl: "male-profile-photo4",
                numberOfBeds: 4,
                pricePerMonth: 6000,
                latitude: 28.6517,
                longitude: 77.2219,
                imageURLs: ["hostel4.jpg"],
                address: "Rajouri Garden",
                city: "Delhi",
                state: "Delhi",
                title: "Budget Boys Hostel",
                rating: 3.9,
                features: [.verified],
                amenities: [.wifi, .laundry, .security, .parking],
                type: .hostel,
                gender: .male,
                reviews: []
            )
        ]
    }
}
