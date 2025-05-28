import Foundation
import ComposableArchitecture
@testable import Heros
import Testing
import HorizonNetwork

@MainActor
struct HeroListFeatureTests {
    @Test("Test fetch heroes with success state")
    func testFetchHeroesWithSuccessState() async {
        let store = TestStore(
          initialState: HeroListFeature.State(hero: [], repositryState: HeroRepositoryFeature.State())) {
            HeroListFeature()
          } withDependencies: {
              $0.heroRemoteDataSource = .testValue
        }
        await store.send(.task)
        await store.receive(.repositry(.fetchHeroes(name: nil, isRefreshable: true))) {
            $0.isLoading = false
            $0.repositryState = HeroRepositoryFeature.State(offset: 0, total: 0)
        }
        await store.receive(.repositry(.delegate(.showLoader(true))))
        await store.receive(.viewState(.showLoader(true))) {
            $0.isLoading = true
        }
        await store.receive(.repositry(.response(.success(.mock), 3))) {
            $0.repositryState.total = 3
        }
        await store.receive(.repositry(.delegate(.model(.mock)))) {
            $0.heroes = .mock
            $0.suggestNames = .mock
        }
        await store.receive(.repositry(.delegate(.showLoader(false))))
        await store.receive(.viewState(.showLoader(false))) {
            $0.isLoading = false
        }
    }

    @Test("Test fetch heroes with error state")
    func testFetchHeroesWithErrorState() async {
        let store = TestStore(
          initialState: HeroListFeature.State(hero: [], repositryState: HeroRepositoryFeature.State())) {
            HeroListFeature()
          } withDependencies: {
              $0.heroRemoteDataSource = .failValue
        }
        await store.send(.task)
        await store.receive(.repositry(.fetchHeroes(name: nil, isRefreshable: true))) {
            $0.isLoading = false
            $0.repositryState = HeroRepositoryFeature.State(offset: 0, total: 0)
        }
        await store.receive(.repositry(.delegate(.showLoader(true))))
        await store.receive(.viewState(.showLoader(true))) {
            $0.isLoading = true
        }
        await store.receive(.repositry(.response(.failure(.badRequest), 0)))
        await store.receive(.repositry(.delegate(.showErrorMessage("Something went to wrong"))))
        await store.receive(.viewState(.showErrorMessage("Something went to wrong"))) {
            $0.isLoading = false
            $0.errorMessage = "Something went to wrong"
        }
    }
}
