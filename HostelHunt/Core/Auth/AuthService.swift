import Foundation
import Supabase

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var user: Supabase.User?
    @Published var currentUser: User?

    private var authStateTask: Task<Void, Never>?

    init() {
        authStateTask = Task {
            for await state in await SupabaseManager.shared.client.auth.authStateChanges {
                handleAuthStateChange(state)
            }
        }
        
        Task { await loadUser() }
    }
    
    private func handleAuthStateChange(_ state: (event: AuthChangeEvent, session: Session?)) {
        switch state.event {
        case .signedIn:
            if let session = state.session {
                loadUser(from: session)
            }
        case .signedOut:
            self.user = nil
            self.currentUser = nil
        default:
            break
        }
    }
    
    private func loadUser(from session: Session) {
        self.user = session.user
        Task {
            await loadCurrentUser(for: session.user)
        }
    }

    func loadUser() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            loadUser(from: session)
        } catch {
            self.user = nil
        }
    }

    func loadCurrentUser(for user: Supabase.User) async {
        do {
            let response: User = try await SupabaseManager.shared.client
                .from("users")
                .select()
                .eq("id", value: user.id)
                .single()
                .execute()
                .value
            self.currentUser = response
        } catch {
            print("Error loading user: \(error.localizedDescription)")
        }
    }

    func updateUser(_ user: User) async throws {
        try await SupabaseManager.shared.client
            .from("users")
            .update(user)
            .eq("id", value: user.id)
            .execute()
    }

    func signUp(withEmail email: String, password aString: String, fullName: String, username: String) async throws {
        let response = try await SupabaseManager.shared.client.auth.signUp(
            email: email,
            password: aString,
            data: ["full_name": .string(fullName), "username": .string(username)]
        )
        
        let user = User(id: response.user.id.uuidString, fullname: fullName, email: email, username: username, profileImageUrl: nil, wishlist: [])
        
        do {
            try await SupabaseManager.shared.client
                .from("users")
                .insert(user)
                .execute()
        } catch {
            print("Error inserting user: \(error.localizedDescription)")
        }
        
    }

    func signIn(withEmail email: String, password aString: String) async throws {
        try await SupabaseManager.shared.client.auth.signIn(
            email: email,
            password: aString
        )
    }

    func signOut() async throws {
        try await SupabaseManager.shared.client.auth.signOut()
    }
    
    // MARK: - Wishlist
    
    func addToWishlist(_ listing: Listing) async throws {
        guard var user = currentUser else { return }
        
        var wishlist = user.wishlist ?? []
        wishlist.append(listing.id)
        user.wishlist = wishlist
        
        self.currentUser = user
        try await updateUser(user)
    }
    
    func removeFromWishlist(_ listing: Listing) async throws {
        guard var user = currentUser else { return }
        
        var wishlist = user.wishlist ?? []
        wishlist.removeAll { $0 == listing.id }
        user.wishlist = wishlist
        
        self.currentUser = user
        try await updateUser(user)
    }
    
    func isInWishlist(_ listing: Listing) -> Bool {
        guard let user = currentUser, let wishlist = user.wishlist else { return false }
        return wishlist.contains(listing.id)
    }
}
