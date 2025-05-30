import SwiftUI
import ComposableArchitecture

@Reducer
public struct ResourceGridRowsFeature {
    @ObservableState
    public struct State: Equatable {
        var resourceDetailsRows: IdentifiedArrayOf<ResourceGridRowFeature.State>
        var showUnAvailableContent: Bool {
            resourceDetailsRows.isEmpty
        }
    }

    public enum Action: Equatable {
        case resourceDetailsRows(IdentifiedActionOf<ResourceGridRowFeature>)
        case task
    }

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
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
                contentUnavailable
            }
            .scrollContentBackground(.hidden)
        }
    }
}
extension ResourceGridRowsView {
    @ViewBuilder
    var contentUnavailable: some View {
        if store.showUnAvailableContent {
            ContentUnavailableView {
                Text("No Available Content")
            } description: {
                Text("Try another Hero.")
            }
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack {
            Text("Comics")
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
