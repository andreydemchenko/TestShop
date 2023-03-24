//
//  Coordinator.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import Combine
import SwiftUI

class AppCoordinator: ObservableObject {
    
    enum AppState {
        case signedIn
        case signedOut
    }
    
    @Published var appState: AppState = .signedOut
    static var authService = AuthService()
    static var userSubject = authService.userSubject
    var authCoordinator = AuthCoordinator()
    var mainViewModel = MainViewModel(userSubject: userSubject)
    var mainCoordinator: MainCoordinator?
    var authViewModel = AuthViewModel(authService: authService)
    var homeViewModel = HomeViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        mainCoordinator = MainCoordinator(viewModel: mainViewModel)
  
        authViewModel.$authenticated
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.appState = .signedIn
                } else {
                    self?.appState = .signedOut
                }
            }
            .store(in: &cancellables)
        mainViewModel.$shouldShowSignIn
            .sink { [weak self] shouldShowSignIn in
                if shouldShowSignIn {
                    self?.authViewModel.signOut()
                    self?.authCoordinator.start()
                }
            }
            .store(in: &cancellables)
    }
    
}
