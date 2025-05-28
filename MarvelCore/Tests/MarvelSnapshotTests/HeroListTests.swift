import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroListTests {
    @Test
    func heroListLoaded() {
    let view = NavigationStack {
        HeroListView(
            store: Store(
                initialState: HeroListFeature.State(
                    heroes: .mock,
                    repositoryState: HeroRepositoryFeature.State()
                ),
                reducer: { HeroListFeature()
                }
            )
        )
        .navigationTitle("Heros")
    }

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
  }
}
