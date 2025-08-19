import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: String?
    var wishlist: [String]?
    var deviceToken: String?
}
