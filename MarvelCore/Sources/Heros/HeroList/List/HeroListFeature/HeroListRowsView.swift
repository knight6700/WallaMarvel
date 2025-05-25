import SwiftUI
import ComposableArchitecture

@Reducer
public struct HeroListRowsFeature {
    @ObservableState
    public struct State: Equatable {
        var hero: IdentifiedArrayOf<HeroListRowFeature.State> = []
    }
    
    @Dependency(\.heroAPIClient) var apiClient
    
    public enum Action: Equatable {
        case hero(IdentifiedActionOf<HeroListRowFeature>)
        case fetch
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .hero:
                return .none
            case .fetch:
                return .run { [state = state] send in
                    do {
                        let params = HeroesParams()
                        let response = try await self.apiClient.fetchUsers(params)
                        print(response)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .forEach(
            \.hero,
             action: \.hero
        ) {
            HeroListRowFeature()
        }
    }
}
struct HeroListRowsView: View {
    let store: StoreOf<HeroListRowsFeature>
    
    @State var text: String = ""
    var body: some View {
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
        .searchable(text: $text)
        .onSubmit(of: .search, {
            
        })
        .refreshable(action: {
            
        })
        .listStyle(.plain)
        .onAppear {
            store.send(.fetch)
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
