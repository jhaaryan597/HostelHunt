import Foundation

class ExploreService {
    func fetchListings(page: Int, limit: Int) async throws -> [Listing] {
        let allListings = DeveloperPreview.shared.listings
        let startIndex = page * limit
        let endIndex = min(startIndex + limit, allListings.count)
        
        guard startIndex < endIndex else {
            return []
        }
        
        return Array(allListings[startIndex..<endIndex])
    }
    
    func fetchListings(withIDs ids: [String]) async throws -> [Listing] {
        let allListings = DeveloperPreview.shared.listings
        return allListings.filter { ids.contains($0.id) }
    }
}
