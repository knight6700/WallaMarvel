#if DEBUG
import Foundation
extension Array where Element == ResourceItem {
   static var mockResourceItems: [ResourceItem] {
        [
            ResourceItem(
                id: 1,
                imageURL: URL(string: "https://example.com/comic/1"),
                resourceURL: URL(string: "https://example.com/comic/1"),
                name: "Iron Man #1",
                description: "Tony Stark suits up as Iron Man for the first time.",
                price: [
                    PriceResource(price: 2.99, priceType: .printPrice),
                    PriceResource(price: 1.99, priceType: .digitalPurchasePrice)
                ]
            ),
            ResourceItem(
                id: 2,
                imageURL: URL(string: "https://example.com/comic/2"),
                resourceURL: URL(string: "https://example.com/comic/1"),
                name: "Captain America #1",
                description: "Steve Rogers fights for freedom in his first issue.",
                price: [
                    PriceResource(price: 3.99, priceType: .printPrice)
                ]
            ),
            ResourceItem(
                id: 3,
                imageURL: URL(string: "https://example.com/comic/3"),
                resourceURL: URL(string: "https://example.com/comic/1"),
                name: "Black Panther #1",
                description: "The king of Wakanda defends his kingdom.",
                price: [
                    PriceResource(price: 4.99, priceType: .digitalPurchasePrice)
                ]
            )
        ]
    }
}


#endif
