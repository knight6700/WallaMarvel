//
//  SwiftUIView.swift
//  MarvelCore
//
//  Created by MahmoudFares on 24/05/2025.
//
#if DEBUG
import Foundation
import IdentifiedCollections

extension IdentifiedArray where Element == ResourceGridRowFeature.State {
    static var mock: IdentifiedArrayOf<ResourceGridRowFeature.State> {
        [
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 1,
                    resourceURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9.jpg"),
                    name: "Sample Resource",
                    description: "This is a sample resource used for testing purposes.",
                    type: .cover
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 2,
                    resourceURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9.jpg"),
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    type: nil
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 3,
                    resourceURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/80/59d2acf17c923.jpg"),
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    type: nil
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 4,
                    resourceURL: URL(string: "https://www.marvel.com/characters/abomination"),
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    type: nil
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 5,
                    resourceURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9.jpg"),
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    type: nil
                )
            )
        ]
    }
}
#endif
