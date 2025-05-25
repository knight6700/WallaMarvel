import Dependencies
import HorizonNetwork

struct HeroAPIClient {
    let fetchUsers: @Sendable (_ params: HeroesParams) async throws -> Response<HeroesDTO>
}

extension HeroAPIClient: DependencyKey {
    static var liveValue: Self {
        HeroAPIClient(
            fetchUsers: { params in
                try await NetworkApi.request(
                    MarvelServices(
                        requestConfiguration: RequestConfiguration(
                            method: .get,
                            path: "characters",
                            parameters: params,
                            encoding: .UrlEncoding
                        )
                    )
                )
            }
        )
    }
}

//
//extension HeroAPIClient: TestDependencyKey {
//    static var testValue: Self {
//        .init()
//    }
//    
//    static var previewValue: Self {
//        .init()
//    }
//}
//

extension DependencyValues {
    var heroAPIClient: HeroAPIClient {
        get { self[HeroAPIClient.self] }
        set { self[HeroAPIClient.self] = newValue }
    }
}
