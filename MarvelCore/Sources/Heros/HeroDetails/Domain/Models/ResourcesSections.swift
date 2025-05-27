
import Foundation

public enum ResourceSection: String, CaseIterable, Equatable, Hashable, Sendable {
    case stories
    case comics
    case series

    var title: String {
        switch self {
        case .stories: return "Stories"
        case .comics: return "Comics"
        case .series: return "Series"
        }
    }
}
