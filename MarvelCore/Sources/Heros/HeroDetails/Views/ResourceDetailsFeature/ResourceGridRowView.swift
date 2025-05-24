import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct ResourceGridRowFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: Int {
            resource.id
        }
        var showSafari: Bool = false
        let resource: ResourceItem
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case readMoreButtonTapped
    }

    public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .readMoreButtonTapped:
            state.showSafari = true
            return .none
        case .binding:
            return .none
        }
    }
}

struct ResourceGridRowView: View {
    
    @Bindable var store: StoreOf<ResourceGridRowFeature >
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: store.resource.resourceURL) { image in
                    image
                        .resizable()
                        .frame(height: 180)
                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))

                } placeholder: {
                    Image(.placeholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                }
            VStack(alignment: .leading, spacing: 8) {
                Text(store.resource.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(store.resource.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
        .background(Color(.systemBackground)) // fallback color
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $store.showSafari) {
            if let url = store.resource.resourceURL {
                SafariView(url: url)
            }
        }
    }
}

#if DEBUG
#Preview {
    ResourceGridRowView(
        store: Store(
            initialState: ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 1,
                    resourceURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9.jpg"),
                    name: "A-Bomb (HAS)",
                    description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!",
                    type: .cover
                )
            ),
            reducer: {
                ResourceGridRowFeature()
            }
        )
    )
    .padding()
}
#endif
