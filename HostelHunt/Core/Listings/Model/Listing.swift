import Foundation

struct Listing: Identifiable, Codable, Hashable {
    let id: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let numberOfBeds: Int
    var pricePerMonth: Int
    let latitude: Double
    let longitude: Double
    var imageURLs: [String]
    let address: String
    let city: String
    let state: String
    let title: String
    var rating: Double
    var features: [ListingFeatures]
    var amenities: [ListingAmenities]
    let type: ListingType
    let gender: Gender
    var reviews: [Review]
}

struct Review: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let userName: String
    let userImageUrl: String
    let rating: Int
    let comment: String
    let timestamp: Date
}

enum Gender: Int, Codable, Identifiable, Hashable, CaseIterable {
    case male
    case female
    case coed
    
    var description: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .coed: return "Co-ed"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum ListingFeatures: Int, Codable, Identifiable, Hashable {
    case verified
    case mealService
    
    var imageName: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .mealService: return "fork.knife.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .verified: return "Verified"
        case .mealService: return "Meal Service"
        }
    }
    
    var subtitle: String {
        switch self {
        case .verified:
            return "This hostel has been verified by HostelHunt."
        case .mealService:
            return "Delicious and hygienic meals available."
        }
    }
    
    var id: Int { return self.rawValue }
}

enum ListingAmenities: Int, Codable, Identifiable, Hashable {
    case wifi
    case laundry
    case ac
    case studyRoom
    case security
    case parking
    
    var title: String {
        switch self {
        case .wifi: return "Wifi"
        case .laundry: return "Laundry"
        case .ac: return "AC"
        case .studyRoom: return "Study Room"
        case .security: return "Security"
        case .parking: return "Parking"
        }
    }
    
    var imageName: String {
        switch self {
        case .wifi: return "wifi"
        case .laundry: return "washer"
        case .ac: return "air.conditioner.horizontal.fill"
        case .studyRoom: return "book.fill"
        case .security: return "lock.shield.fill"
        case .parking: return "parkingsign.circle.fill"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum ListingType: Int, Codable, Identifiable, Hashable {
    case hostel
    case pg
    
    var description: String {
        switch self {
        case .hostel: return "Hostel"
        case .pg: return "PG"
        }
    }
    
    var id: Int { return self.rawValue }
}
