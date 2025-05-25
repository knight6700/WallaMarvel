import Foundation
import HorizonKeys

final class ConstantKeys {
    static let shared = ConstantKeys()

    let publicKey: String
    let privateKey: String

    private init() {
        #if DEBUG
        let keys = HorizonKeys.Debug()
        #else
        let keys = HorizonKeys.Release()
        #endif
        self.publicKey = keys.publicKey
        self.privateKey = keys.privateKey
    }
}
