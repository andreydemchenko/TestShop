//
//  Product.swift
//  TestStorik
//
//  Created by andreydem on 18.03.2023.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let imageUrl: URL?
    let price: Double
    let discount: Int?
    let seller: String?
}
