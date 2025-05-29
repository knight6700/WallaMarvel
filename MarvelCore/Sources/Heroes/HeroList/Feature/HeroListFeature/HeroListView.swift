import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct HeroListFeature {
    @ObservableState
    public struct State: Equatable {
        var heroes: IdentifiedArrayOf<HeroListRowFeature.State> = []
        var repositoryState: HeroRepositoryFeature.State
        var searchText: String = ""
        var suggestNames: IdentifiedArrayOf<SearchSuggestions> = []
        var filteredSuggestions: [SearchSuggestions] {
            return suggestNames
                .sorted { $0.name < $1.name }
                .filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        var name: String? {
            searchText.isEmpty ? nil : searchText
        }
        var showUnAvailableContent: Bool {
            heroes.isEmpty &&
            !searchText.isEmpty &&
            !isLoading
        }

        public init(
            heroes: IdentifiedArrayOf<HeroListRowFeature.State>,
            repositoryState: HeroRepositoryFeature.State
        ) {
            self.heroes = heroes
            self.repositoryState = repositoryState
        }
        var isLoading = false
        var errorMessage: String? = nil
    }
    @Dependency(\.heroPreFetch) var preFetch
    public init () {}
    public enum ViewState: Equatable {
        case showLoader(Bool)
        case showErrorMessage(String?)
    }
    
    public enum Delegate: Equatable {
        case navigateToHeroDetails(Hero)
    }
    
    public enum Action: Equatable, BindableAction {
        case heroes(IdentifiedActionOf<HeroListRowFeature>)
        case fetch(isRefreshable: Bool)
        case repository(HeroRepositoryFeature.Action)
        case binding(BindingAction<State>)
        case reload
        case delegate(Delegate)
        case task
        case viewState(ViewState)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .reload:
                state.heroes.removeAll()
                return .concatenate(
                    .send(.repository(.cancel)),
                    .send(.viewState(.showLoader(true))),
                    .send(.fetch(isRefreshable: true))
                )
            case let .heroes(.element(id, action: action)):
                switch action {
                case .rowOnAppear:
                    guard state.shouldLoadMoreHeroes(for: id)
                    else {
                        return .none
                    }
                    preFetch.preFetch(state.heroes.map { $0.hero.imageURL} )
                    return .send(.fetch(isRefreshable: false))
                case .rowTapped:
                    guard let hero = state.heroes[id: id]?.hero else {
                        return .none
                    }
                    return .send(.delegate(.navigateToHeroDetails(hero)))
                }
            case let .fetch(isRefreshable):
                return .send(.repository(.fetchHeroes(name: state.name, isRefreshable: isRefreshable)))
            case let .repository(.delegate(delegateAction)):
                switch delegateAction {
                case let .model(heroes):
                    let heroes = IdentifiedArray(uniqueElements: heroes.map { HeroListRowFeature.State(hero: $0) })
                    state.heroes.append(contentsOf: heroes)
                    state.suggestNames.append(
                        contentsOf: IdentifiedArray(
                            uniqueElements: heroes.map { hero in
                                SearchSuggestions(id: hero.hero.heroId, name: hero.hero.name)
                            }
                        )
                    )
                    return .none
                case let .showLoader(isLoading):
                    return .send(.viewState(.showLoader(isLoading)))
                case let .showErrorMessage(errorMessage):
                    return .send(.viewState(.showErrorMessage(errorMessage)))
                }
            case .repository, .binding, .delegate:
                return .none
            case .task:
                guard state.heroes.isEmpty else {
                    return .none
                }
                return .send(.repository(.fetchHeroes(name: state.name, isRefreshable: true)))
            case let .viewState(viewState):
                switch viewState {
                case .showLoader(let bool):
                    state.isLoading = bool
                    state.errorMessage = nil
                case let .showErrorMessage(errorDescription):
                    state.isLoading = false
                    state.errorMessage = errorDescription
                }
                return .none
            }
        }
        .forEach(
            \.heroes,
             action: \.heroes
        ) {
            HeroListRowFeature()
        }
        Scope(
            state: \.repositoryState,
            action: \.repository
        ) {
            HeroRepositoryFeature()
        }
    }
}
extension HeroListFeature.State {
    func shouldLoadMoreHeroes(for id: Hero.ID) -> Bool {
        guard heroes.count > 5,
              id == heroes[heroes.count - 5].id,
              repositoryState.total > heroes.count - 1
        else {
            return false
        }
        return true
    }
}
public struct HeroListView: View {
    @Bindable var store: StoreOf<HeroListFeature>
    @FocusState private var isFocused: Bool
    public init(store: StoreOf<HeroListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(
                store.scope(
                    state: \.heroes,
                    action: \.heroes
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
                store.send(.fetch(isRefreshable: false))
            }
        )
        .searchable(text: $store.searchText)
        .searchSuggestions {
            ForEach(store.filteredSuggestions, id: \.id) { suggestion in
                Button {
                    store.searchText = suggestion.name
                } label: {
                    Label(suggestion.name, systemImage: "bookmark")
                }
             }
        }
        .onSubmit(of: .search) {
            store.send(.reload)
        }
        .refreshable(
            action: {
                await store.send(.reload, animation: .smooth).finish()
            }
        )
        .listStyle(.plain)
        .onChange(of: store.searchText, { oldValue, newValue in
            if newValue.isEmpty && oldValue != newValue {
                store.send(.reload, animation: .smooth)
            }
        })
        .task(
            {
                await store.send(.task, animation: .smooth).finish()
            }
        )
        .overlay {
            if store.showUnAvailableContent {
                ContentUnavailableView {
                    Label("No Heroes for \"\(store.searchText)\"", systemImage: "magnifyingglass")
                } description: {
                    Text("Try to search for another Hero.")
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
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
}
#endif
