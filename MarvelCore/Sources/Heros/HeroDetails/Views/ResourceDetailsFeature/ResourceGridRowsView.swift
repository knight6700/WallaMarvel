import SwiftUI
import ComposableArchitecture

@Reducer
public struct ResourceGridRowsFeature {
    @ObservableState
    public struct State: Equatable {
        var resourceDetailsRows: IdentifiedArrayOf<ResourceGridRowFeature.State>
    }
    
    public enum Action: Equatable {
        case resourceDetailsRows(IdentifiedActionOf<ResourceGridRowFeature>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
                .none
        }
        .forEach(
            \.resourceDetailsRows,
             action: \.resourceDetailsRows
        ) {
            ResourceGridRowFeature()
        }
    }
}
struct ResourceGridRowsView: View {
    let store: StoreOf<ResourceGridRowsFeature>
    let rows = [
        GridItem(.flexible(minimum: 180), spacing: 16)
    ]

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
                    GridRow {
                        ForEach(
                            store.scope(
                                state: \.resourceDetailsRows,
                                action: \.resourceDetailsRows
                            )
                        ) { childStore in
                            ResourceGridRowView(store: childStore)
                                .frame(
                                    width: (proxy.size.width / 3),
                                    height: proxy.size.height
                                )
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack {
            Text("wswsws")
            ResourceGridRowsView(
                store: Store(
                    initialState: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                    reducer: { ResourceGridRowsFeature() }
                )
            )
            .frame(height: 290)
            .padding()
        }
    }
}
#endif
