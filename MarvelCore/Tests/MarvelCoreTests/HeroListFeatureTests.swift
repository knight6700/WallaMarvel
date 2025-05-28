import Foundation
import ComposableArchitecture
@testable import Heros
import Testing

@MainActor
struct HeroListFeatureTests {
    @Test("Test to verify Loading initial state")
    func testInitialStateIsLoading() async {
        let store = TestStore(
          initialState: HeroListFeature.State(hero: [], repositryState: HeroRepositryFeature.State())) {
            HeroListFeature()
          } withDependencies: {
              $0.heroRemoteDataSource = .testValue
        }
        await store.send(.task)
        await store.receive(.repositry(.fetchHeroes(name: nil, isRefeshabale: true))) {
            $0.isLoading = false
            $0.repositryState = HeroRepositryFeature.State(offset: 0, total: 0)
        }
        await store.receive(.repositry(.delegate(.showLoader(true))))
        await store.receive(.viewState(.showLoader(true))) {
            $0.isLoading = true
        }
        await store.receive(.repositry(.response(.success(.mock), 3))) {
            $0.repositryState.total = 3
        }
        await store.receive(.repositry(.delegate(.model(.mock)))) {
            $0.hero = .mock
            $0.suggestNames = .mock
        }
        await store.receive(.repositry(.delegate(.showLoader(false))))
        await store.receive(.viewState(.showLoader(false))) {
            $0.isLoading = false
        }
//        await store.send(.binding(.set(\.searchText, "Iron Man"))) {
//            $0.searchText = "Iron Man"
//        }
//        store.send(<#T##action: HeroListFeature.Action##HeroListFeature.Action#>)
    }
}
