import SwiftUI
import ComposableArchitecture

@Reducer
public struct ResourceSectionFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: Int {
            sectionType.rawValue
        }
        let sectionType: ResourceSection
        var resources: ResourceGridRowsFeature.State
    }
    
    public enum Action: Equatable {
        case resources(ResourceGridRowsFeature.Action)
    }
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .resources:
                return .none
            }
        }
    }
}

struct ResourceSectionView: View {
    
    let store: StoreOf<ResourceSectionFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(store.sectionType.title)
            ResourceGridRowsView(
                store: store.scope(
                    state: \.resources,
                    action: \.resources
                )
            )
        }
    }
}

#if DEBUG
#Preview {
    GeometryReader { proxy in
        ScrollView {
            ResourceSectionView(
                store: Store(
                    initialState: ResourceSectionFeature.State(
                        sectionType: .stories,
                        resources: ResourceGridRowsFeature.State(
                            resourceDetailsRows: .mock
                        )
                    ),
                    reducer: { ResourceSectionFeature()
                    }
                )
            )
            .padding()
        }
    }
}
#endif
