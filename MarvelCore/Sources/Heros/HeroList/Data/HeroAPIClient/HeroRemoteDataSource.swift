import Dependencies
import HorizonNetwork

struct HeroRemoteDataSource {
    let fetchHereos: @Sendable (_ params: HeroesParams) async throws -> Response<HeroesDTO>
}

extension HeroRemoteDataSource: DependencyKey {
    static var liveValue: Self {
        HeroRemoteDataSource(
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

extension HeroRemoteDataSource: TestDependencyKey {
    static var testValue: Self {
        HeroRemoteDataSource(
            fetchHereos: { _ in
                Response<HeroesDTO>(code: 200, status: "Success", copyright: "", attributionText: "", attributionHTML: "", etag: "", data: .mock)
            }
        )
    }
    
    static var previewValue: Self {
        HeroRemoteDataSource(
            fetchHereos: { _ in
                Response<HeroesDTO>(code: 200, status: "Success", copyright: "", attributionText: "", attributionHTML: "", etag: "", data: .mock)
            }
        )
    }
}

extension DependencyValues {
    var heroRemoteDataSource: HeroRemoteDataSource {
        get { self[HeroRemoteDataSource.self] }
        set { self[HeroRemoteDataSource.self] = newValue }
    }
}
