import Foundation
import HorizonNetwork

struct HeroesParams: Encodable {
    let name: String?
    let offset: Int
    let limit: Int = 20
    init(
        name: String? = nil,
        offset: Int
    ) {
        self.name = name
        self.offset = offset
    }
}
