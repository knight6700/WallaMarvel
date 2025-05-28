#if DEBUG
import Foundation
import IdentifiedCollections
extension IdentifiedArray where Element == SearchSuggestions {
    static var mock: IdentifiedArrayOf<SearchSuggestions> {
        [
            SearchSuggestions(id: 1, name: "Iron Man"),
            SearchSuggestions(id: 2, name: "Captain America"),
            SearchSuggestions(id: 3, name: "Thor")
        ]
    }
}

#endif
