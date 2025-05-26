import Foundation

public struct Hero: Identifiable, Equatable {
    public let id: Int
    let imageURL: URL?
    let name: String
    let shortDescription: String
}
