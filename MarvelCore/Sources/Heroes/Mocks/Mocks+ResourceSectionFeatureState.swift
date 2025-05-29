#if DEBUG
import Foundation
import IdentifiedCollections

extension IdentifiedArray where Element == ResourceSectionFeature.State {
    static var mock: IdentifiedArrayOf<ResourceSectionFeature.State> {
        [
            ResourceSectionFeature.State(
                sectionType: .comics,
                resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                heroDetailsRepository: HeroDetailsRepositoryFeature.State(),
                hereId: 1
            ),
            ResourceSectionFeature.State(
                sectionType: .series,
                resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                heroDetailsRepository: HeroDetailsRepositoryFeature.State(),
                hereId: 2
            ),
            ResourceSectionFeature.State(
                sectionType: .stories,
                resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                heroDetailsRepository: HeroDetailsRepositoryFeature.State(),
                hereId: 3
            )
        ]
    }
}

#endif
