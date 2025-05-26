import SwiftUI
import ComposableArchitecture

@Reducer
public struct HeroListRowFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: String {
            hero.id
        }
        let hero: Hero
    }
    
    public enum Action: Equatable {
        case rowTapped
        case rowOnAppear
    }
    
    public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        return .none
    }
    
}
struct HeroListRowView: View {
    
    let store: StoreOf<HeroListRowFeature>
    
    var body: some View {
        HeroCell(hero: store.hero)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 4))
            .onAppear {
                store.send(.rowOnAppear)
            }
            .onTapGesture {
                store.send(.rowTapped)
            }
    }
}

#if DEBUG
#Preview {
    HeroListRowView(
        store: Store(
            initialState: HeroListRowFeature.State(hero: .mock),
            reducer: { HeroListRowFeature() }
        )
    )
}
#endif
