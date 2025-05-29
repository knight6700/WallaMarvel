import Foundation
import CryptoKit
import HorizonKeys

public struct MarvelAuthParameters: Encodable {
     let apiKey: String
     let timestamp: String
     let hash: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "apikey"
        case timestamp = "ts"
        case hash
    }
    
    public init() {
        self.timestamp = String(Int(Date().timeIntervalSince1970))
        self.apiKey = AppConfig.publicKey
        self.hash = MD5HashGenerator(
            timeStamp: timestamp,
            privateKey: AppConfig.privateKey,
            apiKey: apiKey
        ).generate()
    }
     
}
