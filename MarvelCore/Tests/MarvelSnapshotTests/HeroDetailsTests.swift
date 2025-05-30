import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroDetailsTests {
    @Test
    func heroDetailsLoaded() {
        let view = HeroDetailsView(
            store: Store(
                initialState: HeroDetailsFeature.State(
                    sections: ResourcesSectionsFeature.State(
                        rows: [
                            ResourceSectionFeature.State(
                                sectionType: .comics,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                hereId: 1
                            ),
                            ResourceSectionFeature.State(
                                sectionType: .series,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                hereId: 2
                            ),
                            ResourceSectionFeature.State(
                                sectionType: .stories,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                hereId: 3
                            ),
                        ]
                    ),
                    hero: Hero(
                        id: "0",
                        heroId: 0,
                        imageURL: nil,
                        name: "Fares",
                        shortDescription: "Fares Junior"
                    )
                ),
                reducer: {
                    HeroDetailsFeature()
                }
            )
        )
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
