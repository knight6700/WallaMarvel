import Foundation
import CryptoKit
import HorizonKeys
import Dependencies

public struct GenerateMarvelSignature {
    let apiKey: String
    let privateKey: String
    let timestamp: String
    
    lazy var hash: String  = {
        generator.generate(timestamp, privateKey, apiKey)
    }()
    
    let generator: Generator
        
    public init(
        generator: Generator,
        date: Int,
        apiKey: String,
        privateKey: String
    ) {
        self.timestamp = String(date)
        self.apiKey = apiKey
        self.privateKey = privateKey
        self.generator = generator
    }
}

extension GenerateMarvelSignature: DependencyKey {
    public static var liveValue: GenerateMarvelSignature {
        GenerateMarvelSignature(
            generator: .liveValue,
            date: Int(Date().timeIntervalSince1970),
            apiKey: AppConfig.publicKey,
            privateKey: AppConfig.privateKey
        )
    }
}

extension GenerateMarvelSignature: TestDependencyKey, Sendable {
    public static var testValue: GenerateMarvelSignature {
        GenerateMarvelSignature(
            generator: .testValue,
            date: Int(Date().timeIntervalSince1970),
            apiKey: AppConfig.publicKey,
            privateKey: AppConfig.privateKey
        )
    }
}
public extension DependencyValues {
    var signature: GenerateMarvelSignature {
        get { self[GenerateMarvelSignature.self] }
        set { self[GenerateMarvelSignature.self] = newValue }
    }
}
