import SwiftUI
import ComposableArchitecture
import HorizonNetwork

@Reducer
public struct HeroDetailsRepositoryFeature {
    @ObservableState
    public struct State: Equatable {}

    @Dependency(\.heroDetailsRemoteDataSource) var remoteDataSource
    // TODO: - Move mapper from here and implement Mapper in ResourceSectionFeature
    @Dependency(\.heroDetailsMapper) var heroDetailsMapper

    public enum Delegate: Equatable {
        case model([ResourceItem])
        case showLoader(Bool)
        case showErrorMessage(String?)
    }

    public enum Action: Equatable {
        case fetch(heroId: Int, sectionType: ResourceSection)
        case response(Result<[ResourceItem], APIError>)
        case delegate(Delegate)
    }

    public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case let .fetch(heroId, sectionType):
            return .run { [ remoteDataSource = self.remoteDataSource, mapper = self.heroDetailsMapper ] send in
                do {
                    await send(.delegate(.showLoader(true)))
                    let response = try await remoteDataSource.fetchHeroDetails(heroId, sectionType)
                    let mapper = mapper.toDomain(response.data.results)
                    await send(.response(.success(mapper)))
                } catch {
                    guard let error = error as? APIError else {
                        return
                    }
                    await send(.response(.failure(error)))
                }
            }
        case .response(let result):
            switch result {
            case .success(let model):
                return .send(.delegate(.model(model)))
            case .failure(let failure):
                return .send(.delegate(.showErrorMessage(failure.errorDescription ?? "Something went to wrong")))
            }
        case .delegate:
            return .none
        }
    }
}
