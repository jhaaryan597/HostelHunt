import Foundation

class ExploreService {
    // Set this to true when your Supabase database is ready with listings table
    private let useSupabase = false

    func fetchListings(page: Int, limit: Int) async throws -> [Listing] {
        if useSupabase {
            // Supabase implementation (enable when database is ready)
            do {
                let startIndex = page * limit
                let endIndex = startIndex + limit - 1

                let response: [Listing] = try await SupabaseManager.shared.client
                    .from("listings")
                    .select()
                    .range(from: startIndex, to: endIndex)
                    .order("created_at", ascending: false)
                    .execute()
                    .value

                print("DEBUG: Fetched \(response.count) listings from Supabase (page \(page))")
                return response
            } catch {
                print("DEBUG: Supabase fetch failed: \(error.localizedDescription)")
                // Fall through to mock data
            }
        }

        // Mock data (default for development)
        print("DEBUG: Using mock data (page \(page))")
        let allListings = DeveloperPreview.shared.listings
        let startIndex = page * limit
        let endIndex = min(startIndex + limit, allListings.count)

        guard startIndex < endIndex else {
            return []
        }

        return Array(allListings[startIndex..<endIndex])
    }

    func fetchListings(withIDs ids: [String]) async throws -> [Listing] {
        if useSupabase {
            // Supabase implementation (enable when database is ready)
            do {
                let response: [Listing] = try await SupabaseManager.shared.client
                    .from("listings")
                    .select()
                    .in("id", values: ids)
                    .execute()
                    .value

                print("DEBUG: Fetched \(response.count) listings by IDs from Supabase")
                return response
            } catch {
                print("DEBUG: Supabase fetch failed: \(error.localizedDescription)")
                // Fall through to mock data
            }
        }

        // Mock data (default for development)
        print("DEBUG: Using mock data for wishlist IDs")
        let allListings = DeveloperPreview.shared.listings
        return allListings.filter { ids.contains($0.id) }
    }
}
