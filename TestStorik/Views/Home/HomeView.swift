//
//  HomeView.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import SwiftUI

enum SaleSelection {
    case latest
    case flash
    case brands
    
    var title: String {
        switch self {
        case .latest:
            return "Latest"
        case .flash:
            return "Flash Sale"
        case .brands:
            return "Brands"
        }
    }
}

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var coordinator = HomeCoordinator()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                HeaderBarView(image: "person_image")
                
                SearchBarView(viewModel: viewModel)
                
                // Categories section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.categories) { category in
                            CategoryView(category: category)
                                .onTapGesture {
                                    // Code to show category products
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Latest sale section
                SaleSectionView(viewModel: viewModel, type: .latest, coordinator: coordinator)
                
                // Flash sale section
                SaleSectionView(viewModel: viewModel, type: .flash, coordinator: coordinator)
                
                // Brands section
                SaleSectionView(viewModel: viewModel, type: .brands, coordinator: coordinator)
            }
        }
        .background(CustomColor.baseColor)
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct HeaderBarView: View {
    @State var image: String
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image("ico_header_button")
                    .frame(width: 25, height: 28)
                    .padding(4)
                    .padding(.leading, 12)
            }
            Spacer(minLength: 60)
            Group {
                Text("Trade by ")
                    .foregroundColor(.black)
                    .font(.boldMontserratFont(size: 20))
                +
                Text("bata")
                    .foregroundColor(CustomColor.blueColor)
                    .font(.boldMontserratFont(size: 20))
            }
               
            VStack(alignment: .trailing) {
                Image(image)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .padding(.trailing, 40)
                    .padding(.top, 20)
                HStack(spacing: 2) {
                    Spacer()
                    Text("Location")
                        .foregroundColor(CustomColor.grayColor)
                        .font(.montserratFont(size: 10))
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 7, height: 5)
                        .foregroundColor(CustomColor.grayColor)
                        .padding(.top, 1)
                }
                .padding( .trailing, 35)
            }
        }
    }
}

struct SearchBarView: View {
    @ObservedObject var viewModel: HomeViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(CustomColor.fieldColor)
                    
                    HStack {
                        Spacer()
                        VStack {
                            TextField("", text: $viewModel.searchQuery)
                                .focused($isTextFieldFocused)
                                .font(.montserratFont(size: 11))
                                .foregroundColor(CustomColor.grayColor)
                                .padding(8)
                                .overlay(
                                    Text("What are you looking for?")
                                        .foregroundColor(CustomColor.grayColor)
                                        .multilineTextAlignment(.center)
                                        .font(.montserratFont(size: 10))
                                        .padding(.leading, 20)
                                        .opacity(viewModel.searchQuery.isEmpty ? 1 : 0)
                                        .onTapGesture {
                                            isTextFieldFocused = true
                                        }
                                )
                        }
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(CustomColor.grayColor)
                            .padding(.trailing, 16)
                    }
                }
                .frame(height: 20)
                .padding([.leading, .trailing], 40)
                
                if !$viewModel.matchingWords.isEmpty {
                    GeometryReader { geometry in
                        VStack {
                            ForEach(viewModel.matchingWords, id: \.self) { word in
                                Text(word)
                                    .padding()
                                    .foregroundColor(.black)
                                    .font(.montserratFont(size: 10))
                                    .onTapGesture {
                                        viewModel.searchQuery = ""
                                    }
                            }
                        }
                        .background(CustomColor.fieldColor)
                        .cornerRadius(10)
                        .frame(width: geometry.size.width, height: CGFloat(viewModel.matchingWords.count) * 20.0)
                    }
                }
            }
        }
        .zIndex(1)
    }
}

    
struct CategoryView: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 10) {
            Image(category.icon)
                .foregroundColor(.black)
                .padding(0)
            
            Text(category.name)
                .font(.montserratFont(size: 9))
                .foregroundColor(.gray)
        }
        .frame(width: 60, height: 60)
    }
}
    
struct SaleSectionView: View {
    @ObservedObject var viewModel: HomeViewModel
    let type: SaleSelection
    @ObservedObject var coordinator: HomeCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(type.title)
                    .font(.boldMontserratFont(size: 16))
                
                Spacer()
                
                Button(action: {
                    // Code to show all products
                }, label: {
                    Text("View all")
                        .font(.montserratFont(size: 10))
                        .foregroundColor(CustomColor.grayColor)
                        .padding(8)
                })
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    switch type {
                    case .latest:
                        ForEach(viewModel.latestItems, id: \.id) { item in
                            LatestSaleItemView(viewModel: viewModel, item: item)
                                .onTapGesture {
                                    coordinator.navigation = .productDetails(product: item)
                                }
                        }
                    case .flash:
                        ForEach(viewModel.flashItems, id: \.id) { item in
                            FlashSaleItemView(viewModel: viewModel, item: item)
                                .onTapGesture {
                                    coordinator.navigation = .productDetails(product: item)
                                }
                        }
                    case .brands:
                        ForEach(viewModel.brandItems, id: \.id) { item in
                            BrandSaleItemView(imageName: item.imageName)
                                .onTapGesture {
                                    //coordinator.navigation = .productDetails(product: item)
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
    
struct LatestSaleItemView: View {
    let viewModel: HomeViewModel
    @State var item: Product
  
    var body: some View {
          ZStack(alignment: .bottomLeading) {
              if let url = item.imageUrl {
                  RemoteImage(url: url)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 120, height: 160)
                      .cornerRadius(10)
              } else {
                  Image("mock_sale_item")
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 120, height: 160)
                      .cornerRadius(10)
              }
              
              VStack(alignment: .leading) {
                  Text(item.category)
                      .font(.montserratFont(size: 10))
                      .foregroundColor(.black)
                      .padding(.horizontal, 8)
                      .background(Color(red: 196/255, green: 196/255, blue: 196/255).opacity(0.8))
                      .cornerRadius(20)
                  Text(item.name)
                      .font(.boldMontserratFont(size: 10))
                      .frame(maxWidth: 70)
                      .foregroundColor(.white)
                      .padding(2)
                      .lineLimit(2)
                  Text("$\(item.price, specifier: "%.2f")")
                      .font(.montserratFont(size: 10))
                      .foregroundColor(.white)
                      .padding(2)
              }
              .padding(.leading, 4)
              .padding(.bottom, 6)
              
              HStack {
                  Spacer()
                  
                  Button(action: {
                      viewModel.addToCart(product: item)
                  }) {
                      Image(systemName: "plus")
                          .foregroundColor(CustomColor.secondaryColor)
                          .padding(4)
                          .background(CustomColor.primaryColor)
                          .clipShape(Circle())
                  }
              }
              .padding(.trailing, 8)
              .padding(.bottom, 8)
          }
          .frame(width: 120, height: 160)
    }
}

struct FlashSaleItemView: View {
    let viewModel: HomeViewModel
    @State var item: Product
    
    @State private var isLiked = false
    
    var body: some View {
          ZStack(alignment: .bottomLeading) {
              if let url = item.imageUrl {
                  RemoteImage(url: url)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 165, height: 220)
                      .cornerRadius(10)
              } else {
                  Image("mock_sale_item")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 165, height: 220)
                      .cornerRadius(10)
              }
              
              VStack(alignment: .leading) {
                  HStack(alignment: .top) {
                      Image("person_image")
                          .resizable()
                          .frame(width: 25, height: 25)
                          .clipShape(Circle())
                      Spacer()
                      if let discount = item.discount, discount > 0 {
                          Text("\(discount)% off")
                              .font(.montserratFont(size: 12))
                              .padding(4)
                              .foregroundColor(.white)
                              .background(Color.red)
                              .clipShape(Capsule())
                      }
                  }
                  Spacer()
              }
              .padding(10)
              
              VStack(alignment: .leading) {
                  Text(item.category)
                      .font(.boldMontserratFont(size: 10))
                      .foregroundColor(.black)
                      .padding(.vertical, 6)
                      .padding(.horizontal, 12)
                      .background(Color(red: 196/255, green: 196/255, blue: 196/255).opacity(0.8))
                      .cornerRadius(20)
                  Text(item.name)
                      .font(.boldMontserratFont(size: 14))
                      .foregroundColor(.white)
                      .padding(4)
                      .lineLimit(2)
                  Text("$\(item.price, specifier: "%.2f")")
                      .font(.boldMontserratFont(size: 10))
                      .foregroundColor(.black)
                      .padding(4)
              }
              .padding(.leading, 8)
              .padding(.bottom, 12)
              
              // like and plus buttons
              HStack {
                  Spacer()
                  Button(action: {
                      isLiked.toggle()
                      viewModel.like(product: item)
                  }) {
                      Image(systemName: isLiked ? "heart.fill" : "heart")
                          .foregroundColor(isLiked ? Color.red : CustomColor.secondaryColor)
                          .padding(6)
                          .background(CustomColor.primaryColor)
                          .clipShape(Circle())
                  }
                  
                  Button(action: {
                      viewModel.addToCart(product: item)
                  }) {
                      Image(systemName: "plus")
                          .foregroundColor(CustomColor.secondaryColor)
                          .padding(10)
                          .background(CustomColor.primaryColor)
                          .clipShape(Circle())
                  }
              }
              .padding(.trailing, 8)
              .padding(.bottom, 8)
          }
          .frame(width: 165, height: 220)
      }
    
}

struct BrandSaleItemView: View {
    @State var imageName: String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 150)
                .cornerRadius(10)
        }
        .frame(width: 120, height: 150)
        .padding(2)
    }
    
}

struct RemoteImage: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
//                    .onAppear {
//                        ImageCache.shared.set( image.asUIImage(), forKey: url.absoluteString)
//                    }
            case .failure:
                Image(systemName: "xmark.square")
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }
//        .onAppear {
//            if let cachedImage = ImageCache.shared.get(forKey: url.absoluteString) {
//                // Use the cached image if available
//                DispatchQueue.main.async {
//                    Image(uiImage: cachedImage)
//                }
//            }
//        }
    }
}

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
