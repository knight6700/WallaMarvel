#if DEBUG
import Foundation
import IdentifiedCollections

extension Hero {
    static let mock: Self = Hero(
        id: 0,
        imageURL: nil,
        name: "Hulk",
        shortDescription: "Hulk is Hulk"
    )
}

extension Array where Element == Hero {
    static let mock: [Hero] = [
        Hero(
            id: 1,
            imageURL: nil,
            name: "Iron Man",
            shortDescription: "Genius billionaire playboy philanthropist."
        ),
        Hero(
            id: 2,
            imageURL: nil,
            name: "Captain America",
            shortDescription: "The first Avenger."
        ),
        Hero(
            id: 3,
            imageURL: nil,
            name: "Thor",
            shortDescription: "God of Thunder."
        )
    ]
}
extension IdentifiedArray where Element == HeroListRowFeature.State {
    static var mock: IdentifiedArrayOf<HeroListRowFeature.State> {
        [
            HeroListRowFeature.State(
                hero: Hero(
                    id: 1,
                    imageURL: nil,
                    name: "Iron Man",
                    shortDescription: "Genius billionaire playboy philanthropist."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: 2,
                    imageURL: nil,
                    name: "Captain America",
                    shortDescription: "The first Avenger."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: 3,
                    imageURL: nil,
                    name: "Thor",
                    shortDescription: "God of Thunder."
                )
            )
        ]
    }

}
#endif
