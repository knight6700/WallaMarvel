
import Foundation

enum ResourceSection: Int, CaseIterable, Equatable, Hashable {
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
