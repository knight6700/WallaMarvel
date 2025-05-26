import Dependencies
import HorizonNetwork

struct HeroAPIClient {
    let fetchHereos: @Sendable (_ params: HeroesParams) async throws -> Response<HeroesDTO>
}

extension HeroAPIClient: DependencyKey {
    static var liveValue: Self {
        HeroAPIClient(
            fetchHereos: { params in
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

extension HeroAPIClient: TestDependencyKey {
    static var testValue: Self {
        previewValue
    }
    
    static var previewValue: Self {
        HeroAPIClient(
            fetchHereos: { _ in
                Response<HeroesDTO>(code: 200, status: "Success", copyright: "", attributionText: "", attributionHTML: "", etag: "", data: .mock)
            }
        )
    }
}

extension DependencyValues {
    var heroAPIClient: HeroAPIClient {
        get { self[HeroAPIClient.self] }
        set { self[HeroAPIClient.self] = newValue }
    }
}
