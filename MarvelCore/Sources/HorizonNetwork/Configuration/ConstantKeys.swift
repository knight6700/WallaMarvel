import Foundation
import HorizonKeys

enum ConstantKeys {
    static var publicKey: String {
        #if DEBUG
                HorizonKeys.Debug().publicKey
        #else
                HorizonKeys.Debug().privateKey
        #endif
    }
    static var privateKey: String {
        #if DEBUG
                HorizonKeys.Release().publicKey
        #else
                HorizonKeys.Release().privateKey
        #endif
    }
}
