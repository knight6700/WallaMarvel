import Dependencies
import Kingfisher
import Foundation

struct HeroPreFetch {
    let preFetch: @Sendable (_ images: [URL?]) -> Void
}

extension HeroPreFetch: DependencyKey {
    static var liveValue: Self {
        .init(preFetch: { images in
            let urls = images.compactMap {$0}
            ImagePrefetcher(urls: urls).start()
        })
    }
}

extension HeroPreFetch: TestDependencyKey {
    static var testValue: Self {
        .liveValue
    }

    static var previewValue: Self {
        .liveValue
    }
}

extension DependencyValues {
    var heroPreFetch: HeroPreFetch {
    get { self[HeroPreFetch.self] }
    set { self[HeroPreFetch.self] = newValue }
  }
}
