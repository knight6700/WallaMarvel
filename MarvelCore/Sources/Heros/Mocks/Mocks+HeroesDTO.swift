#if DEBUG
import Foundation

extension HeroesDTO {
    static var mock: HeroesDTO {
        .init(
            offset: 0,
            limit: 20,
            total: 1,
            count: 1,
            results: [.mock]
        )
    }
}

extension HeroResult {
    static var mock: HeroResult {
        .init(
            id: 1009610,
            name: "Spider-Man",
            description: "Bitten by a radioactive spider, Peter Parker uses his powers to help others.",
            modified: Date(),
            thumbnail: .mock,
            resourceURI: "http://gateway.marvel.com/v1/public/characters/1009610",
            comics: .mock,
            series: .mock,
            stories: .mock,
            events: .mock,
            urls: [.mockDetail, .mockWiki, .mockComicLink]
        )
    }
}

extension Thumbnail {
    static var mock: Thumbnail {
        .init(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16",
            thumbnailExtension: .jpg
        )
    }
}

extension Comics {
    static var mock: Comics {
        .init(
            available: 12,
            collectionURI: "http://gateway.marvel.com/v1/public/characters/1009610/comics",
            items: [
                .init(resourceURI: "http://gateway.marvel.com/v1/public/comics/62304", name: "Amazing Spider-Man (2018) #1")
            ],
            returned: 1
        )
    }
}

extension Stories {
    static var mock: Stories {
        .init(
            available: 2,
            collectionURI: "http://gateway.marvel.com/v1/public/characters/1009610/stories",
            items: [
                .init(resourceURI: "http://gateway.marvel.com/v1/public/stories/1234", name: "Cover #1234", type: .cover),
                .init(resourceURI: "http://gateway.marvel.com/v1/public/stories/5678", name: "Interior #5678", type: .interiorStory)
            ],
            returned: 2
        )
    }
}

extension URLElement {
    static var mockDetail: URLElement {
        .init(type: .detail, url: "http://marvel.com/characters/54/spider-man?utm_campaign=apiRef&utm_source=xyz")
    }

    static var mockWiki: URLElement {
        .init(type: .wiki, url: "http://marvel.com/universe/Spider-Man_(Peter_Parker)?utm_campaign=apiRef&utm_source=xyz")
    }

    static var mockComicLink: URLElement {
        .init(type: .comiclink, url: "http://marvel.com/comics/characters/1009610/spider-man?utm_campaign=apiRef&utm_source=xyz")
    }
}
#endif
