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
    case studyRoom
    case commonArea
    case parking
    case rooftop
    case garden
    
    var imageName: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .mealService: return "fork.knife.circle.fill"
        case .studyRoom: return "book.fill"
        case .commonArea: return "person.3.fill"
        case .parking: return "parkingsign.circle.fill"
        case .rooftop: return "building.2.fill"
        case .garden: return "leaf.fill"
        @unknown default:
            return "star.fill"
        }
    }
    
    var title: String {
        switch self {
        case .verified: return "Verified"
        case .mealService: return "Meal Service"
        case .studyRoom: return "Study Room"
        case .commonArea: return "Common Area"
        case .parking: return "Parking"
        case .rooftop: return "Rooftop Access"
        case .garden: return "Garden"
        @unknown default:
            return "New Feature"
        }
    }
    
    var subtitle: String {
        switch self {
        case .verified:
            return "This hostel has been verified by HostelHunt."
        case .mealService:
            return "Delicious and hygienic meals available."
        case .studyRoom:
            return "Dedicated space for studying and academics."
        case .commonArea:
            return "Shared space for socializing and relaxation."
        case .parking:
            return "Secure parking space available."
        case .rooftop:
            return "Access to rooftop area for recreation."
        case .garden:
            return "Beautiful garden space for relaxation."
        @unknown default:
            return "Check out this new feature!"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum ListingAmenities: String, Codable, CaseIterable, Identifiable, Hashable {
    case wifi
    case laundry
    case ac
    case studyRoom
    case security
    case parking
    case meals
    case gym
    case pool
    case housekeeping
    
    var title: String {
        switch self {
        case .wifi: return "Wifi"
        case .laundry: return "Laundry"
        case .ac: return "AC"
        case .studyRoom: return "Study Room"
        case .security: return "Security"
        case .parking: return "Parking"
        case .meals: return "Meals"
        case .gym: return "Gym"
        case .pool: return "Swimming Pool"
        case .housekeeping: return "Housekeeping"
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
        case .meals: return "fork.knife.circle.fill"
        case .gym: return "dumbbell.fill"
        case .pool: return "figure.pool.swim"
        case .housekeeping: return "house.fill"
        }
    }
    
    var id: String { return self.rawValue }
}

enum ListingType: Int, Codable, Identifiable, Hashable {
    case hostel
    case pg
    case coliving
    
    var description: String {
        switch self {
        case .hostel: return "Hostel"
        case .pg: return "PG"
        case .coliving: return "Co-living"
        }
    }
    
    var id: Int { return self.rawValue }
}
