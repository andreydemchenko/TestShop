//
//  ProductDetails.swift
//  TestStorik
//
//  Created by andreydem on 21.03.2023.
//

import Foundation

struct ProductDetails: Codable {
    var name: String
    var description: String
    var rating: Double
    var numberOfReviews: Int
    var price: Double
    var colors: [String]
    var imageUrls: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case rating
        case numberOfReviews = "number_of_reviews"
        case price
        case colors
        case imageUrls = "image_urls"
    }
}
