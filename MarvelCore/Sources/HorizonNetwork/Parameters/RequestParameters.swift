import Foundation
import HorizonKeys

public protocol RequestParameters: Encodable {
    var apikey: String { get }
    var ts: String { get }
}

extension RequestParameters {
    var apikey: String {
        return HorizonKeys.Debug().privateKey
    }

    var ts: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
}
