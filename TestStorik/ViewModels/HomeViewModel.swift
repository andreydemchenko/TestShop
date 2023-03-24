//
//  РщьуМшуцЬщвуд.swift
//  TestStorik
//
//  Created by andreydem on 18.03.2023.
//

import Combine
import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var latestItems: [Product] = []
    @Published var flashItems: [Product] = []
    @Published var brandItems: [Brand] = []
    @Published var searchQuery: String = ""
    @Published var matchingWords: [String] = []
    private var searchingWords: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Properties for the categories
    let categories: [Category] = [
        Category(name: "Phones", icon: "ico_phone"),
        Category(name: "Headphones", icon: "ico_headphones"),
        Category(name: "Games", icon: "ico_game"),
        Category(name: "Cars", icon: "ico_car"),
        Category(name: "Furniture", icon: "ico_furniture"),
        Category(name: "Kids", icon: "ico_robot")
    ]
    
    init() {
        searchWords()
        $searchQuery
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { query -> [String] in
                guard !query.isEmpty else { return [] }
                let lowercaseQuery = query.lowercased()
                return self.searchingWords.filter { $0.lowercased().starts(with: lowercaseQuery) }
            }
            .sink(receiveValue: { [weak self] words in
                self?.matchingWords = words
            })
            .store(in: &cancellables)
    }
    
     private func searchWords() {
        let urlString = "https://run.mocky.io/v3/4c9cd822-9479-4509-803d-63197e5a9e19"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WordsResponse.self, decoder: JSONDecoder())
            .replaceError(with: WordsResponse(words: []))
            .map(\.words)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] words in
                self?.searchingWords = words
            }
            .store(in: &cancellables)
     }
    
    // Load the latest and flash sale items from the API
    func fetchData() {
        let latestSalePublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://run.mocky.io/v3/cc0071a1-f06e-48fa-9e90-b1c2a61eaca7")!)
            .map { $0.data }
            .decode(type: LatestSaleResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        let flashSalePublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://run.mocky.io/v3/a9ceeb6e-416d-4352-bde6-2203416576ac")!)
            .map { $0.data }
            .decode(type: FlashSaleResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        Publishers.Zip(latestSalePublisher, flashSalePublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] latestSaleResponse, flashSaleResponse in
                self?.latestItems = latestSaleResponse.latest.map { $0.toProduct() }
                self?.flashItems = flashSaleResponse.flash_sale.map { $0.toProduct() }
                self?.brandItems.append(Brand(imageName: "nike"))
                self?.brandItems.append(Brand(imageName: "puma"))
                self?.brandItems.append(Brand(imageName: "adidas"))
            })
            .store(in: &cancellables)
    }
    
    func productTapped(product: Product) {
        
    }
    
    // Handle the add to cart action
    func addToCart(product: Product) {
        // Code to add product to cart
    }
    
    // Handle the like action
    func like(product: Product) {
        // Code to like product
    }
    
}
