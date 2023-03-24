//
//  AuthCoordinator.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import Foundation

class AuthCoordinator: ObservableObject {
    enum Navigation {
        case signIn
        case signUp
    }

    @Published var currentNavigation: Navigation = .signIn

    func navigate(to navigation: Navigation) {
        currentNavigation = navigation
    }

    func start() {
        currentNavigation = .signIn
    }
}
