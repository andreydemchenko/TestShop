//
//  TestStorikApp.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import SwiftUI

@main
struct TestStorikApp: App {
    
    @StateObject var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            switch coordinator.appState {
            case .signedIn:
                MainView(viewModel: coordinator.mainViewModel, coordinator: coordinator.mainCoordinator!)
            case .signedOut:
                AuthView(viewModel: coordinator.authViewModel, coordinator: coordinator.authCoordinator)
            }
        }
    }
}
