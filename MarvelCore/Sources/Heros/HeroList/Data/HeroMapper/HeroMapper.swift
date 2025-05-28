import Dependencies
import Foundation
import HorizonNetwork

struct HeroMapper {
    let toDomain: @Sendable (_ dto: [HeroResult]) -> [Hero]
}

extension HeroMapper: DependencyKey {
    static var liveValue: Self {
        HeroMapper(
            toDomain: { dto in
                dto.map {
                    Hero(
                        id: UUID().uuidString,
                        hereoId: $0.id,
                        imageURL: ThumbnailURLBuilder(thumbnail: $0.thumbnail).build(),
                        name: $0.name,
                        shortDescription: $0.description
                    )
                }
            }
        )
    }
}
extension HeroMapper: TestDependencyKey {
    static var testValue: Self {
        HeroMapper(
            toDomain: { dto in
                    .mock
            }
        )
    }
    
    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var heroMapper: HeroMapper {
    get { self[HeroMapper.self] }
    set { self[HeroMapper.self] = newValue }
  }
}
