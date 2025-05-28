import Dependencies
import IdentifiedCollections

struct ResourceMapper {
    let toDomain: @Sendable ([ResourceItem]) -> ResourceGridRowsFeature.State
}

extension ResourceMapper: DependencyKey {
    static var liveValue: Self {
        ResourceMapper(
            toDomain: { resources in
                ResourceGridRowsFeature.State(
                    resourceDetailsRows: IdentifiedArray(uniqueElements: resources.map {
                        ResourceGridRowFeature.State(resource: $0)
                    }
                                                        )
                )
            }
        )
    }
}

extension DependencyValues {
    var resourceMapper: ResourceMapper {
    get { self[ResourceMapper.self] }
    set { self[ResourceMapper.self] = newValue }
  }
}
