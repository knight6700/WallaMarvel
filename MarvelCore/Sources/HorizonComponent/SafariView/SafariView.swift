import SwiftUI
import SafariServices

public struct SafariView: UIViewControllerRepresentable {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.dismissButtonStyle = .done
        return safariVC
    }

    public func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

#Preview {
    if let url = URL(string: "https://www.marvel.com/characters") {
        SafariView(url: url)
    } else {
        EmptyView()
    }
}
