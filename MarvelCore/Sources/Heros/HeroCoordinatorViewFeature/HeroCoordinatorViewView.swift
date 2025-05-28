import ComposableArchitecture
import SwiftUI

@Reducer
public struct HeroCoordinatorFeature {
    public init() {}
    @Reducer
    public enum Path {
        case heroDetails(HeroDetailsFeature)
        
        var id: StackElementID {
            switch self {
            case .heroDetails:
                StackElementID(integerLiteral: 1)
            }
        }
    }
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()
        var root: HeroListFeature.State
        public init(
            path: StackState<Path.State> = StackState<Path.State>(),
            root: HeroListFeature.State
        ) {
            self.path = path
            self.root = root
        }
    }

    public enum Action {
        case goBackToScreen(id: StackElementID)
        case path(StackActionOf<Path>)
        case popToRoot
        case root(HeroListFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .goBackToScreen:
                return .none
            case .path:
                return .none
            case .popToRoot:
                return .none
            case let .root(.delegate(action)):
                switch action {
                case let .navigateToHeroDetails(hero):
                    state.path.append(.heroDetails(state.hereDetails(hero: hero)))
                    return .none
                }
            case .root:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        Scope(state: \.root, action: \.root) {
            HeroListFeature()
        }
    }
}
extension HeroCoordinatorFeature.State {
    func hereDetails(hero: Hero) -> HeroDetailsFeature.State {
        HeroDetailsFeature.State(
            sections: ResourcesSectionsFeature.State(
                rows: [
                    ResourceSectionFeature.State(
                        sectionType: .comics,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: []),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: hero.hereoId
                    ),
                    ResourceSectionFeature.State(
                        sectionType: .series,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: []),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: hero.hereoId
                    ),
                    ResourceSectionFeature.State(
                        sectionType: .stories,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: []),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: hero.hereoId
                    )
                ]
            ),
            hero: hero
        )
    }
}
public struct HeroCoordinatorFeatureRouterView: View {
    @Bindable var store: StoreOf<HeroCoordinatorFeature>
    public init(store: StoreOf<HeroCoordinatorFeature>) {
        self.store = store
    }
    public var body: some View {
        NavigationStack(
            path: $store.scope(
                state: \.path,
                action: \.path
            )
        ) {
            HeroLisView(
                store: store.scope(
                    state: \.root,
                    action: \.root
                )
            )
            .navigationTitle("Heroes")
        } destination: { store in
            switch store.case {
            case let .heroDetails(childStore):
                HeroDetailsView(store: childStore)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Hero Details")
            }
        }
    }
}
