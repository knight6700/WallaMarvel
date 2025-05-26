import SwiftUI
import ComposableArchitecture
import HorizonNetwork

@Reducer
 public struct HeroRepositryFeature {
    @ObservableState
    public struct State: Equatable {
        var isLoading = false
        var errorMessage: String? = nil
        var offset: Int = -1
        var total: Int = 0
    }
    
    @Dependency(\.heroAPIClient) var remote
    @Dependency(\.heroMapper) var mapper
     
     public enum Delegate: Equatable {
         case model([Hero])
     }
     public enum ViewState: Equatable {
         case showLoader(Bool)
         case showErorMessage(String?)
     }
     
     public enum Action: Equatable {
         case fetchHeroes(name: String?, isRefeshabale: Bool)
         case response(Result<[Hero], APIError>)
         case delegate(Delegate)
         case viewState(ViewState)
     }
    
     public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case let .fetchHeroes(name, isRefeshabale):
            state.offset += 1
            return .run { [ offset = state.offset,
                           remote = remote,
                           mapper = mapper] send in
                do {
                    await send(.viewState(.showLoader(isRefeshabale)))
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
                state.isLoading = false
                state.errorMessage = nil
                return .concatenate(
                    .send(.delegate(.model(heroes))),
                    .send(.viewState(.showLoader(false)))
                )
            case .failure(let failure):
                 state.isLoading = false
                 state.errorMessage = failure.errorDescription
                return .send(.viewState(.showErorMessage(failure.errorDescription)))
            }
        case let .viewState(viewState):
            switch viewState {
            case .showLoader(let bool):
                state.isLoading = bool
                state.errorMessage = nil
            case let .showErorMessage(errorDescription):
                state.isLoading = false
                state.errorMessage = errorDescription
            }
            return .none
        case .delegate:
            return .none
        }
    }
}
