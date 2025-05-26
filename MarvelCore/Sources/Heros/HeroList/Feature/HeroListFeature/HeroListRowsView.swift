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
        var suggetNames: [String] = []
        var filteredSuggestions: [String] {
            return suggetNames.sorted().filter { $0.lowercased().contains(searchText.lowercased()) }
        }

        var name: String? {
            searchText.isEmpty ? nil : searchText
        }
        public init(hero: IdentifiedArrayOf<HeroListRowFeature.State>) {
            self.hero = hero
        }
    }
    @Dependency(\.heroPreFetch) var preFetch
    
    public init() {}
    
    public enum Action: Equatable, BindableAction {
        case hero(IdentifiedActionOf<HeroListRowFeature>)
        case fetch(isRefeshabale: Bool)
        case repositry(HeroRepositryFeature.Action)
        case binding(BindingAction<State>)
        case reload
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
                        return .send(.reload)
                    default:
                        return .none
                    }
                }
            }

        Reduce<State, Action> { state, action in
            switch action {
            case .reload:
                state.hero.removeAll()
                return .send(.fetch(isRefeshabale: true))
            case let .hero(.element(id, action: action)):
                switch action {
                case .rowOnAppear:
                    guard state.hero.count > 5,
                          id == state.hero[state.hero.count - 5].id
                    else {
                        preFetch.preFetch(state.hero.map {$0.hero.imageURL})
                        return .none
                    }
                    return .send(.fetch(isRefeshabale: false))
                case .rowTapped:
                    // TODO: - Navigation
                    return .none
                }
            case let .fetch(isRefeshabale):
                return .send(.repositry(.fetchHeroes(name: state.name, isRefeshabale: isRefeshabale)))
            case let .repositry(.delegate(.model(heroes))):
                let heroes = IdentifiedArray(uniqueElements: heroes.map { HeroListRowFeature.State(hero: $0) })
                state.suggetNames.append(contentsOf: heroes.map {$0.hero.name})
                state.hero.append(contentsOf: heroes)
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
        .searchable(text: $store.searchText, suggestions: {
            ForEach(store.filteredSuggestions, id: \.self) { suggestion in
                Button {
                    store.searchText = suggestion
                } label: {
                   Label(suggestion, systemImage: "bookmark")
                }
             }
        })
        .onSubmit(of: .search, {
            store.send(.reload)
        })
        
        .refreshable(
            action: {
                await store.send(.reload, animation: .smooth).finish()
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
