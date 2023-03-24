//
//  MainViewModel.swift
//  TestStorik
//
//  Created by andreydem on 15.03.2023.
//

import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    
    var profileViewModel: ProfileViewModel?
    var homeViewModel = HomeViewModel()
    
    @Published var user: User?
    let userSubject: CurrentValueSubject<User?, Never>
    @Published var shouldShowSignIn = false
    private var cancellables = Set<AnyCancellable>()
    
    init(userSubject: CurrentValueSubject<User?, Never>) {
        self.userSubject = userSubject
        userSubject
            .sink(receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
        
        profileViewModel = ProfileViewModel(userSubject: userSubject)
        profileViewModel?.$logOutIsActive
            .sink { [weak self] shouldShowSignIn in
                if shouldShowSignIn {
                    self?.shouldShowSignIn = true
                }
            }
            .store(in: &cancellables)
    }
    
}
