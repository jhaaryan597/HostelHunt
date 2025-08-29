import Foundation
import Supabase

struct UserDefaultsStorage: GoTrueLocalStorage {
    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func store(key: String, value: Data) throws {
        userDefaults.set(value, forKey: key)
    }

    func retrieve(key: String) throws -> Data? {
        userDefaults.data(forKey: key)
    }

    func remove(key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
}
