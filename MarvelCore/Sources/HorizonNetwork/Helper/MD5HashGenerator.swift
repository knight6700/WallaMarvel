import Foundation
import CryptoKit
import Dependencies

public struct Generator {
     var generate: @Sendable (_ time: String, _ key: String, _ apiKey: String) -> String
}

extension Generator: DependencyKey {
    public static var liveValue: Generator {
        Generator { time, key, apiKey in
            let hash = "\(time)\(key)\(apiKey)"
            let digest = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
}

extension Generator: TestDependencyKey, Sendable {
    public static var testValue: Generator {
        Generator { time, key, apiKey in
            let hash = "\(time)\(key)\(apiKey)"
            let digest = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}

// Optional: Dependency wrapper access
public extension DependencyValues {
    var generator: Generator {
        get { self[Generator.self] }
        set { self[Generator.self] = newValue }
    }
}
