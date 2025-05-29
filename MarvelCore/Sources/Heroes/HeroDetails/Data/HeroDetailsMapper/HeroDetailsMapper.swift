import Dependencies
import Foundation

struct HeroDetailsMapper {
    let toDomain: @Sendable (_ heroDetails: [ResourcesResult]) -> [ResourceItem]
}

extension HeroDetailsMapper: DependencyKey {
    static var liveValue: Self {
        HeroDetailsMapper(
            toDomain: { dto in
                dto.map {
                    ResourceItem(
                        id: $0.id,
                        imageURL: ThumbnailURLBuilder(thumbnail: $0.thumbnail).build(),
                        resourceURL: URL(string: $0.urls?.compactMap {$0.url}.first ?? ""),
                        name: $0.title,
                        description: $0.description,
                        price:
                            $0.prices?.map {
                                PriceResource(
                                    price: $0.price,
                                    priceType: PriceResourceType(rawValue: $0.type.rawValue) ?? .printPrice
                                )
                            } ?? []
                    )
                }
            }
        )
    }
}

extension HeroDetailsMapper: TestDependencyKey {
    static var testValue: Self {
        HeroDetailsMapper { _ in
                .mockResourceItems
        }
    }

    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var heroDetailsMapper: HeroDetailsMapper {
    get { self[HeroDetailsMapper.self] }
    set { self[HeroDetailsMapper.self] = newValue }
  }
}
