//
//  FlashSaleItem.swift
//  TestStorik
//
//  Created by andreydem on 21.03.2023.
//

import Foundation

struct FlashSaleResponse: Codable {
    let flash_sale: [FlashSaleItem]
}

struct FlashSaleItem: Codable {
    let category: String
    let name: String
    let price: Double
    let discount: Int
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case category
        case name
        case price
        case discount
        case imageUrl = "image_url"
    }
}

extension FlashSaleItem {
    
    func toProduct() -> Product {
        let url = URL(string: imageUrl)
        return Product(name: name, category: category, imageUrl: url, price: price, discount: discount, seller: "item_seller_image")
    }
    
}
