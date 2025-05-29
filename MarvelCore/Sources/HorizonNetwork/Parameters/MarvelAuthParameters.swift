import Foundation
struct MarvelAuthParameters: Encodable {
    let apiKey: String
    let timestamp: String
    let hash: String
    enum CodingKeys: String, CodingKey {
        case apiKey = "apikey"
        case timestamp = "ts"
        case hash
    }
}
