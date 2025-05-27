import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct HeroListFeature {
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
        var isLoading = false
        var errorMessage: String? = nil
    }
    @Dependency(\.heroPreFetch) var preFetch
    
    public enum ViewState: Equatable {
        case showLoader(Bool)
        case showErorMessage(String?)
    }
    
    public enum Delegate: Equatable {
        case navigateToHeroDetails(Hero)
    }
    
    public enum Action: Equatable, BindableAction {
        case hero(IdentifiedActionOf<HeroListRowFeature>)
        case fetch(isRefeshabale: Bool)
        case repositry(HeroRepositryFeature.Action)
        case binding(BindingAction<State>)
        case reload
        case delegate(Delegate)
        case task
        case viewState(ViewState)
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
                return .concatenate(
                    .send(.viewState(.showLoader(true))),
                    .send(.fetch(isRefeshabale: true))
                )
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
                    guard let hero = state.hero[id: id]?.hero else {
                        return .none
                    }
                    return .send(.delegate(.navigateToHeroDetails(hero)))
                }
            case let .fetch(isRefeshabale):
                return .send(.repositry(.fetchHeroes(name: state.name, isRefeshabale: isRefeshabale)))
            case let .repositry(.delegate(delegateAction)):
                switch delegateAction {
                case let .model(heroes):
                    let heroes = IdentifiedArray(uniqueElements: heroes.map { HeroListRowFeature.State(hero: $0) })
                    state.suggetNames.append(contentsOf: heroes.map {$0.hero.name})
                    state.hero.append(contentsOf: heroes)
                    return .none
                case let .showLoader(isLoading):
                    return .send(.viewState(.showLoader(isLoading)))
                case let .showErorMessage(errorMessage):
                    return .send(.viewState(.showErorMessage(errorMessage)))
                }
            case .repositry, .binding, .delegate:
                return .none
            case .task:
                guard state.hero.isEmpty else {
                    return .none
                }
                return .send(.repositry(.fetchHeroes(name: state.name, isRefeshabale: true)))
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

public struct HeroLisView: View {
    @Bindable var store: StoreOf<HeroListFeature>
    
    public init(store: StoreOf<HeroListFeature>) {
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
            isLoading: $store.isLoading,
            error: $store.errorMessage,
            action: {
                // Handle Retry
                store.send(.fetch(isRefeshabale: false))
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
        .task(
            {
                await store.send(.task, animation: .smooth).finish()
            }
        )
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HeroLisView(
            store: Store(
                initialState: HeroListFeature.State(
                    hero: .mock
                ),
                reducer: { HeroListFeature()
                }
            )
        )
        .navigationTitle("Heros")
    }
}
#endif
