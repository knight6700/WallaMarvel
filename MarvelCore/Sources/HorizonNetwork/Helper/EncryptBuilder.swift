//
//  EncryptBuilder.swift
//  MarvelCore
//
//  Created by MahmoudFares on 28/05/2025.
//


public struct EncryptBuilder {
    private let ts: String
    private let privateKey: String
    private let apiKey: String
    public init(
        ts: String,
        privateKey: String,
        apiKey: String
    ) {
        self.ts = ts
        self.privateKey = privateKey
        self.apiKey = apiKey
    }
    func hash() -> String {
        let hash = "\(ts)\(privateKey)\(apiKey)"
        let digest = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}