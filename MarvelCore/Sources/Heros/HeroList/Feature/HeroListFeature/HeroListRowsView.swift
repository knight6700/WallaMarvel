import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct HeroListRowsFeature {
    @ObservableState
    public struct State: Equatable {
        var hero: IdentifiedArrayOf<HeroListRowFeature.State> = []
        var repositryState: HeroRepositryFeature.State = .init()
        var searchText: String = ""
        var name: String? {
            searchText.isEmpty ? nil : searchText
        }
        public init(hero: IdentifiedArrayOf<HeroListRowFeature.State>) {
            self.hero = hero
        }
    }
    public init() {
        
    }
    public enum Action: Equatable, BindableAction {
        case hero(IdentifiedActionOf<HeroListRowFeature>)
        case fetch(isRefeshabale: Bool)
        case repositry(HeroRepositryFeature.Action)
        case binding(BindingAction<State>)
        case search
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.searchText) { oldValue, newValue in
                Reduce { state, action in
                    switch action {
                    case .binding(\.searchText):
                        guard oldValue != newValue else {
                            return .none
                        }
                        return .send(.search)
                    default:
                        return .none
                    }
                }
            }

        Reduce<State, Action> { state, action in
            switch action {
            case .search:
                return .send(.fetch(isRefeshabale: true))
            case let .hero(.element(id, action: action)):
                switch action {
                case .rowOnAppear:
                    guard state.hero.count > 5,
                          id == state.hero[state.hero.count - 5].id
                    else { return .none }
                    // TODO: -  LoadMore
                    return .send(.fetch(isRefeshabale: false))
                case .rowTapped:
                    // TODO: - NAvigation
                    return .none
                }
            case let .fetch(isRefeshabale):
                return .send(.repositry(.fetchHeroes(name: state.name, isRefeshabale: isRefeshabale)))
            case let .repositry(.delegate(.model(hereos))):
                let hereos = IdentifiedArray(uniqueElements: hereos.map { HeroListRowFeature.State(hero: $0) })
                state.hero.append(contentsOf: hereos)
                return .none
            case .repositry, .binding:
                return .none
            }
        }
        .forEach(
            \.hero,
             action: \.hero
        ) {
            HeroListRowFeature()
        }
        Scope(
            state: \.repositryState,
            action: \.repositry
        ) {
            HeroRepositryFeature()
        }
    }
}

public struct HeroListRowsView: View {
    @Bindable var store: StoreOf<HeroListRowsFeature>
    
    public init(store: StoreOf<HeroListRowsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(
                store.scope(
                    state: \.hero,
                    action: \.hero
                )
            ) { childStore in
                HeroListRowView(store: childStore)
            }
        }
        .loadingErrorOverlay(
            isLoading: $store.repositryState.isLoading,
            error: $store.repositryState.errorMessage,
            action: {
                
            }
        )
        .searchable(text: $store.searchText)
        .onSubmit(of: .search, {
            store.send(.fetch(isRefeshabale: true))
        })
        
        .refreshable(
            action: {
                await store.send(.fetch(isRefeshabale: true), animation: .smooth).finish()
            }
        )
        .listStyle(.plain)
        .onAppear {
            store.send(.fetch(isRefeshabale: true))
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HeroListRowsView(
            store: Store(
                initialState: HeroListRowsFeature.State(
                    hero: .mock
                ),
                reducer: { HeroListRowsFeature()
                }
            )
        )
        .navigationTitle("Heros")
    }
}
#endif
