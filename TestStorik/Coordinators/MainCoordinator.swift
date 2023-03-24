//
//  MainCoordinator.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import Combine
import SwiftUI

class MainCoordinator: ObservableObject {
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    enum Navigation {
        case home(HomeViewModel)
        case favorites
        case cart
        case chat
        case profile(ProfileViewModel)
        
        @ViewBuilder
        var destinationView: some View {
            switch self {
            case .home(let viewModel):
                HomeView(viewModel: viewModel)
            case .favorites:
                FavoritesView()
            case .cart:
                CartView()
            case .chat:
                ChatView()
            case .profile(let viewModel):
                ProfileView(viewModel: viewModel)
            }
        }
        
        var imageName: String {
            switch self {
            case .home:
              return "ico_home"
            case .favorites:
                return "ico_favorites"
            case .cart:
                return "ico_cart"
            case .chat:
                return "ico_chat"
            case .profile:
                return "ico_profile"
            }
        }
        
        var title: String {
            switch self {
            case .home:
              return "Home"
            case .favorites:
                return "Favorites"
            case .cart:
                return "Cart"
            case .chat:
                return "Chat"
            case .profile:
                return "Profile"
            }
        }
        
    }
    
    @Published var currentNavigation: Navigation?
    
    func navigate(to navigation: Navigation) {
        currentNavigation = navigation
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    func start(viewModel: HomeViewModel) {
        currentNavigation = .home(viewModel)
    }

}
