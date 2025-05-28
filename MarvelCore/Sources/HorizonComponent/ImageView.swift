import SwiftUI
import Kingfisher

public struct ImageView: View {
    let url: URL?
    let size: CGSize?
    let placeholder: Images
    @State private var loadFailed = false
    public init(
        url: URL?,
        size: CGSize,
        placeholder: Images,
        loadFailed: Bool = false
    ) {
        self.url = url
        self.size = size
        self.placeholder = placeholder
        self.loadFailed = loadFailed
    }
    
    public var body: some View {
        if loadFailed {
            if let size = size {
                Image(placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: size.height)
                    .clipped()
            }else {
                Image(.placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
            }
        } else {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .progressViewStyle(.linear)
                }
                .onFailure { error in
                    loadFailed = true
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: size?.width ?? 200)
                .frame(minHeight: 200)
                .clipped()
        }
    }
    
}

#Preview {
    ImageView(
        url: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"),
        size: CGSize(width: 200, height: 200),
        placeholder: .placeholder
    )
    .clipShape(Circle())
}
