//
//  LatestSaleItem.swift
//  TestStorik
//
//  Created by andreydem on 21.03.2023.
//

import Foundation

struct LatestSaleResponse: Codable {
    let latest: [LatestSaleItem]
}

struct LatestSaleItem: Codable {
    let category: String
    let name: String
    let price: Double
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case category
        case name
        case price
        case imageUrl = "image_url"
    }

}

extension LatestSaleItem {
    
    func toProduct() -> Product {
        let url = URL(string: imageUrl)
        return Product(name: name, category: category, imageUrl: url, price: price, discount: nil, seller: nil)
    }
    
}
