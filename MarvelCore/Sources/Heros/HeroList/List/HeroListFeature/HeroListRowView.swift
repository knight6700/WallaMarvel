import SwiftUI
import ComposableArchitecture

@Reducer
public struct HeroListRowFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: Int
    }
    
    public enum Action: Equatable {
        
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
        VStack {
            Text("Hello, World!")
        }
    }
}

#if DEBUG
#Preview {
    HeroListRowView(
        store: Store(
            initialState: HeroListRowFeature.State(id: .zero),
            reducer: { HeroListRowFeature() }
        )
    )
}
#endif
