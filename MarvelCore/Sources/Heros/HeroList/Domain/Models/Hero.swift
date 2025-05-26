import Foundation

public struct Hero: Identifiable, Equatable {
    public let id: String
    let hereoId: Int
    let imageURL: URL?
    let name: String
    let shortDescription: String
}
