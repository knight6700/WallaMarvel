
import Foundation

public enum ResourceSection: String, CaseIterable, Equatable, Hashable, Sendable {
    case stories
    case comics
    case series

    var title: String {
        switch self {
        case .stories: "Stories"
        case .comics: "Comics"
        case .series: "Series"
        }
    }
}
