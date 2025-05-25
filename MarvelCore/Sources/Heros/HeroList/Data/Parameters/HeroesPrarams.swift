import Foundation
import HorizonNetwork

struct HeroesParams: RequestParameters {
    let name: String?
    let baseRequesParameter: BaseRequestParameters

    init(name: String? = nil) {
        self.name = name
        self.baseRequesParameter = BaseRequestParameters()
    }

    enum CodingKeys: String, CodingKey {
        case name, apikey, ts, hash
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let name {
            try container.encode(name, forKey: .name)
        }
        try container.encode(baseRequesParameter.apikey, forKey: .apikey)
        try container.encode(baseRequesParameter.ts, forKey: .ts)
        try container.encode(baseRequesParameter.hash, forKey: .hash)
    }
}
