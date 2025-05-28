import Foundation

public struct Hero: Identifiable, Equatable {
    public let id: String
    let heroId: Int
    let imageURL: URL?
    let name: String
    let shortDescription: String
}
