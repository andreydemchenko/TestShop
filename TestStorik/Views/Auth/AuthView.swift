//
//  AuthView.swift
//  TestStorik
//
//  Created by andreydem on 13.03.2023.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var coordinator: AuthCoordinator
    
    var body: some View {
        switch coordinator.currentNavigation {
        case .signIn:
            SignInView(viewModel: viewModel, coordinator: coordinator)
        case .signUp:
            SignUpView(viewModel: viewModel, coordinator: coordinator)
        }
    }
}
