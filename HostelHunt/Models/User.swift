import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: String?
    var wishlist: [String]?
    var deviceToken: String?
    var phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, fullname, email, username, profileImageUrl, wishlist, deviceToken, phoneNumber
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fullname = try container.decode(String.self, forKey: .fullname)
        email = try container.decode(String.self, forKey: .email)
        username = try container.decode(String.self, forKey: .username)
        profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        wishlist = try container.decodeIfPresent([String].self, forKey: .wishlist)
        deviceToken = try container.decodeIfPresent(String.self, forKey: .deviceToken)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }

    init(id: String, fullname: String, email: String, username: String, profileImageUrl: String?, wishlist: [String]?, deviceToken: String?, phoneNumber: String?) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.wishlist = wishlist
        self.deviceToken = deviceToken
        self.phoneNumber = phoneNumber
    }
}
