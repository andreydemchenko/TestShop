//
//  ProductViewModel.swift
//  TestStorik
//
//  Created by andreydem on 21.03.2023.
//

import Foundation
import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
   
    @State var product = ProductDetails(name: "", description: "", rating: 0, numberOfReviews: 0, price: 0, colors: [], imageUrls: [])
    @State var selectedPhotoIndex = 0
    @State var selectedColorIndex = 0
    @State var quantity = 1
    private var cancellables = Set<AnyCancellable>()
        
    func fetchProductDetails() {
        guard let url = URL(string: "https://example.com/product-details.json") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductDetails?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] product in
                if let product {
                    self?.product = product
                }
            })
            .store(in: &cancellables)

    }
    
    var photos: [String] {
        product.imageUrls
    }
    
    var selectedPhoto: String {
        photos[selectedPhotoIndex]
    }
    
    var colors: [String] {
        product.colors
    }
    
    var selectedColor: String {
        colors[selectedColorIndex]
    }
    
    var price: Double? {
        product.price * Double(quantity)
    }
    
    func addToCart() {
        // TODO: Add product to cart
    }
}
