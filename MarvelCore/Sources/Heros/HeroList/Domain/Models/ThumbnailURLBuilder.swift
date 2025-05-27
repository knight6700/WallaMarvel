import Foundation

struct ThumbnailURLBuilder {
    private var path: String?
    private var ext: Extension?
    private var variant: String?

    init(thumbnail: Thumbnail?) {
        self.path = thumbnail?.path
        self.ext = thumbnail?.thumbnailExtension
    }

    func build() -> URL? {
        guard let path, let ext else { return nil }
        var components = URLComponents(string: path)
        components?.scheme = "https"

        let base = components?.url?.absoluteString ?? path
        let fullPath: String
        if let variant = variant {
            fullPath = "\(base)/\(variant).\(ext.rawValue)"
        } else {
            fullPath = "\(base).\(ext.rawValue)"
        }

        return URL(string: fullPath)
    }
}
