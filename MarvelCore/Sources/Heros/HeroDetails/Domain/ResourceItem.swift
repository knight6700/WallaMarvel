import Foundation

struct ResourceItem: Identifiable, Equatable {
    let id: Int
    let resourceURL: URL?
    let name: String
    let description: String
    let type: StoryType?
}

enum StoryType: String, Codable, Equatable {
    case interiorStory
    case cover
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = StoryType(rawValue: rawValue) ?? .unknown
    }
    var typeDescription: String {
        switch self {
        case .interiorStory: return "Interior"
        case .cover: return "Cover"
        case .unknown: return "Unknown"
        }
    }
}
