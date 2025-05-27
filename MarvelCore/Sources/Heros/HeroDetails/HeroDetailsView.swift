import SwiftUI
import ComposableArchitecture

@Reducer
public struct HeroDetailsFeature {
    @ObservableState
    public struct State: Equatable {
        var sections: ResourcesSectionsFeature.State
        let hero: Hero?
    }
    public enum Action: Equatable {
        case sections(ResourcesSectionsFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
                .none
        }
        Scope(
            state: \.sections,
            action: \.sections,
            child: {
                ResourcesSectionsFeature()
            }
        )
    }
}

struct HeroDetailsView: View {
    let store: StoreOf<HeroDetailsFeature>
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    if let hero = store.hero {
                        HeroHeaderView(hero: hero)
                    }
                    ResourceSectionsView(store: store.scope(state: \.sections, action: \.sections))
                        .frame(height: geo.size.height + 200)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HeroDetailsView(
        store: Store(
            initialState: HeroDetailsFeature.State(
                sections: ResourcesSectionsFeature.State(
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
                            hereId: 2
                        )
                    ]
                ),
                hero: Hero(
                    id: "0",
                    hereoId: 0,
                    imageURL: nil,
                    name: "Fares",
                    shortDescription: "Fares Junior"
                )
            ),
            reducer: {
                HeroDetailsFeature()
            }
        )
    )
}
