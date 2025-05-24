import SwiftUI

public enum Images: String {
    case placeholder = "placeholderMarvel"
}


public extension Image {
    init(_ name: Images) {
        self.init(name.rawValue, bundle: .module)
    }
}

