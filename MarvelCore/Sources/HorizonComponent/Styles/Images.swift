import SwiftUI

public enum Images: String {
    case placeholder = "heroPlaceholder"
}

public extension Image {
    init(_ name: Images) {
        self.init(name.rawValue, bundle: .module)
    }
}
