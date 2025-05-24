import SwiftUI
import ComposableArchitecture

@Reducer
public struct HeroListRowsFeature {
    @ObservableState
    public struct State: Equatable {
        var hero: IdentifiedArrayOf<HeroListRowFeature.State> = []
    }
    
    public enum Action: Equatable {
        case hero(IdentifiedActionOf<HeroListRowFeature>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
                .none
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
