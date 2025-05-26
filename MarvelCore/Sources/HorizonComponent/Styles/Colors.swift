import SwiftUI
import Foundation

public enum Colors: String {
    case primary
    case secondary
}

public extension Color {
    init(_ name: Colors) {
        self.init(name.rawValue, bundle: .module)
    }
}
