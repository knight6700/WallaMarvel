import Foundation
import HorizonKeys

enum Environment {
    case debug
    case release

    static let current: Self = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()
    // TODO: Handle Different Environments
    var baseHost: String {
        switch self {
        case .debug, .release:
            return "gateway.marvel.com"
        }
    }
    // TODO: Handle Different Environments
    var basePort: Int {
        switch self {
        case .debug, .release:
            return 443
        }
    }
}
