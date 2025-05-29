import SwiftUI
import ComposableArchitecture

@Reducer
public struct ResourcesSectionsFeature {
    @ObservableState
    public struct State: Equatable {
         var rows: IdentifiedArrayOf<ResourceSectionFeature.State>
    }

    public enum Action: Equatable {
        case rows(IdentifiedActionOf<ResourceSectionFeature>)
    }

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .rows:
                return .none
            }
        }
        .forEach(
            \.rows,
             action: \.rows
        ) {
            ResourceSectionFeature()
        }
    }
}
struct ResourceSectionsView: View {

    let store: StoreOf<ResourcesSectionsFeature>

    var body: some View {
        VStack {
            ForEachStore(
                store.scope(state: \.rows, action: \.rows)
            ) { rowStore in
                ResourceSectionView(store: rowStore)
            }
        }
    }
}

#if DEBUG
#Preview {
    ResourceSectionsView(
        store: Store(
            initialState: ResourcesSectionsFeature.State(
                rows: .mock
            ),
            reducer: { ResourcesSectionsFeature()
            }
        )
    )
}
#endif
