//
//  ProductView.swift
//  TestStorik
//
//  Created by andreydem on 21.03.2023.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                productPhotos
                
                productDescription
                
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchProductDetails()
        }
    }
    
    private var productPhotos: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                TabView(selection: $viewModel.selectedPhotoIndex) {
                    ForEach(0..<viewModel.photos.count) { index in
                        Image(viewModel.photos[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: geometry.size.width)
            }
            
            HStack(spacing: 8) {
                ForEach(0..<viewModel.photos.count) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(viewModel.selectedPhotoIndex == index ? .blue : .gray)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                        .padding(.vertical, 8)
                        .onTapGesture {
                            viewModel.selectedPhotoIndex = index
                        }
                }
            }
        }
    }
    
    private var productDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let description = viewModel.product.description {
                Text(description)
                    .font(.body)
                    .lineLimit(nil)
            }
            
            if let rating = viewModel.product.rating{
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
