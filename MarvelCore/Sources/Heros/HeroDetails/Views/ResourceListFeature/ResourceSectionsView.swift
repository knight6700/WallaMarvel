import SwiftUI
import ComposableArchitecture

@Reducer
public struct ResourcesSectionsFeature {
    @ObservableState
    public struct State: Equatable {
         var rows: IdentifiedArrayOf<ResourceSectionFeature.State>

         init(
            rows: IdentifiedArrayOf<ResourceSectionFeature.State>
        ) {
            self.rows = rows
        }
    }
    
    public enum Action: Equatable {
        case rows(IdentifiedActionOf<ResourceSectionFeature>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
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
        VStack(alignment: .leading) {
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
                rows: [
                    ResourceSectionFeature.State(
                        sectionType: .comics,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: 1
                    ),
                    ResourceSectionFeature.State(
                        sectionType: .series,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: 2
                    ),
                    ResourceSectionFeature.State(
                        sectionType: .stories,
                        resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: 3
                    ),
                ]
            ),
            reducer: { ResourcesSectionsFeature()
            }
        )
    )
}
#endif
