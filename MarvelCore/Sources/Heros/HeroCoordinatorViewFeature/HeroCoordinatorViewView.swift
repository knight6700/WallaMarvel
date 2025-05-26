import ComposableArchitecture
import SwiftUI

@Reducer
public struct HeroCoordinatorFeature {
    public init() {}
    @Reducer
    public enum Path {
        case heroDetails(HeroDetailsFeature)
        
        var id: StackElementID {
            switch self {
            case .heroDetails:
                StackElementID(integerLiteral: 1)
            }
        }
    }
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()
        public init(
            path: StackState<Path.State> = StackState<Path.State>()
        ) {
            self.path = path
        }
    }

    public enum Action {
        case goBackToScreen(id: StackElementID)
        case path(StackActionOf<Path>)
        case popToRoot
        case root
        case delegate(Delegate)
    }
    public enum Delegate {
        case showHomeScreen
    }
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goBackToScreen:
                return .none
            case let .path(action):
                switch action {
                case let .element(id: _, action: .heroDetails(heroState)):
//                    state.path.append(.heroDetails)
                    return .none
                default:
                    return .none
                }
            case .popToRoot:
                return .none
            case .root:
//                state.path.append(.child)
                return .none
            case .root:
                return .none
            case .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
public struct HeroCoordinatorFeatureRouterView: View {
    @Bindable var store: StoreOf<HeroCoordinatorFeature>
    public init(store: StoreOf<HeroCoordinatorFeature>) {
        self.store = store
    }
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Text("RootView")
        } destination: { store in
            switch store.case {
            case .heroDetails:
                Text("ChildViews")
            }
        }
    }
}
