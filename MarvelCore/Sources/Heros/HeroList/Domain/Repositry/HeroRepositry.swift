import SwiftUI
import ComposableArchitecture
import HorizonNetwork

@Reducer
 public struct HeroRepositryFeature {
    @ObservableState
    public struct State: Equatable {
        var offset: Int = -1
        var total: Int = 0
    }
    
    @Dependency(\.heroRemoteDataSource) var remote
    @Dependency(\.heroMapper) var mapper
     
     public enum Delegate: Equatable {
         case model([Hero])
         case showLoader(Bool)
         case showErorMessage(String?)
     }
     
     public enum Action: Equatable {
         case fetchHeroes(name: String?, isRefeshabale: Bool)
         case response(Result<[Hero], APIError>)
         case delegate(Delegate)
     }
    
     public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case let .fetchHeroes(name, isRefeshabale):
            state.offset = isRefeshabale ? 0 : state.offset + 1
            return .run { [offset = state.offset,
                           remote = remote,
                           mapper = mapper] send in
                do {
                    await send(.delegate(.showLoader(isRefeshabale)))
                    let params = HeroesParams(name: name, offset: offset)
                    let response = try await remote.fetchHereos(params)
                    let domainModel = mapper.toDomain(response.data.results)
                    await send(.response(.success(domainModel)))
                } catch {
                    guard let error = error as? APIError else {
                        return
                    }
                    await send(.response(.failure(error)))
                }
            }
        case let .response(result):
            switch result {
            case .success(let heroes):
                return .concatenate(
                    .send(.delegate(.model(heroes))),
                    .send(.delegate(.showLoader(false)))
                )
            case .failure(let failure):
                return .send(.delegate(.showErorMessage(failure.errorDescription)))
            }
        case .delegate:
            return .none
        }
    }
}
