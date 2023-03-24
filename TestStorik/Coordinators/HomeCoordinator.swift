//
//  HomeCoordinator.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import Foundation
import SwiftUI

class HomeCoordinator: ObservableObject {
    
    enum Navigation {
        case none
        case productDetails(product: Product)
        case profile
        
//        @ViewBuilder
//        var destinationView: some View {
//            switch self {
//            case .none:
//                HomeView(viewModel: MainViewModel.homeViewModel)
//            case .productDetails(_):
//                ProductView(viewModel: ProductViewModel())
//            case .profile:
//                ProfileView(viewModel: MainViewModel.profileViewModel)
//            }
//        }
    }
    
    @Published var navigation: Navigation = .none

}
