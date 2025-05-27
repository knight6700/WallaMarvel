import SwiftUI
import HorizonNetwork
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct ResourceSectionFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: String {
            sectionType.rawValue
        }

        let sectionType: ResourceSection
        var resources: ResourceGridRowsFeature.State
        var heroDetailsRepository: HeroDetailsRepositryFeature.State
        var isLoading: Bool = false
        var errorMessage: String?
        let hereId: Int
        init(
            sectionType: ResourceSection,
            resources: ResourceGridRowsFeature.State,
            heroDetailsRepository: HeroDetailsRepositryFeature.State,
            hereId: Int
        ) {
            self.sectionType = sectionType
            self.resources = resources
            self.heroDetailsRepository = heroDetailsRepository
            self.hereId = hereId
        }
    }
    
    @Dependency(\.resourceMapper) var resourceMapper
    
    public enum Action: Equatable, BindableAction {
        case resources(ResourceGridRowsFeature.Action)
        case heroDetailsRepository(HeroDetailsRepositryFeature.Action)
        case binding(BindingAction<State>)
        case task
        case viewSate(ViewSate)
    }
    
    public enum ViewSate: Equatable {
        case showLoder(isLoading: Bool)
        case showErorMessage(message: String?)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .task:
                return .send(.heroDetailsRepository(.fetch(heroId: state.hereId, sectionType: state.sectionType)))
            case .resources:
                return .none
            case let .heroDetailsRepository(.delegate(delegateAction)):
                switch delegateAction {
                case let .model(model):
                    let resources = resourceMapper.toDomain(model)
                    state.resources = resources
                    return .send(.viewSate(.showLoder(isLoading: false)))
                case let .showLoader(isLoading):
                    return .send(.viewSate(.showLoder(isLoading: isLoading)))
                case let .showErorMessage(errorMessage):
                    return .send(.viewSate(.showErorMessage(message: errorMessage)))
                }
            case .heroDetailsRepository, .binding:
                return .none
            case let .viewSate(viewSate):
                switch viewSate {
                case let .showLoder(isLoading):
                    state.isLoading = isLoading
                    state.errorMessage = nil
                case let .showErorMessage(errorMessage):
                    state.isLoading = false
                    state.errorMessage = errorMessage
                }
                return .none
            }
        }
        Scope(
            state: \.heroDetailsRepository,
            action: \.heroDetailsRepository
        ) {
            HeroDetailsRepositryFeature()
        }
    }
}

struct ResourceSectionView: View {
    
   @Bindable var store: StoreOf<ResourceSectionFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(store.sectionType.title)
                Spacer()
                Button("See All") {
                    // TODO: - Handle See All
                }
            }
            ResourceGridRowsView(
                store: store.scope(
                    state: \.resources,
                    action: \.resources
                )
            )
            .loadingErrorOverlay(
                isLoading: $store.isLoading,
                error: $store.errorMessage
            ) {
                 store.send(.task, animation: .smooth)
            }
            .task {
                await store.send(.task, animation: .smooth).finish()
            }
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
                        ),
                        heroDetailsRepository: HeroDetailsRepositryFeature.State(),
                        hereId: 0
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
