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
        case task
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .task:
                return .none
            case .resourceDetailsRows:
                return .none
            }
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
    @Bindable var store: StoreOf<ResourceGridRowsFeature>
    let rows = [
        GridItem(.flexible(minimum: 180), spacing: 16)
    ]

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                        ForEach(
                            store.scope(
                                state: \.resourceDetailsRows,
                                action: \.resourceDetailsRows
                            )
                        ) { childStore in
                            ResourceGridRowView(store: childStore)
                                .frame(
                                    width: (proxy.size.width / 2),
                                    height: proxy.size.height
                                )
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
