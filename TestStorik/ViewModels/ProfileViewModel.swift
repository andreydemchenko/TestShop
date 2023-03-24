//
//  ProfileViewModel.swift
//  TestStorik
//
//  Created by andreydem on 17.03.2023.
//

import Combine
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var profileImage: UIImage?
    @Published var name: String = "John Doe"
    @Published var balance: Double = 1593.0
    @Published var tradeHistoryIsActive: Bool = false
    @Published var restorePurchaseIsActive: Bool = false
    @Published var helpIsActive: Bool = false
    @Published var logOutIsActive: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(userSubject: CurrentValueSubject<User?, Never>) {
        userSubject
            .sink(receiveValue: { [weak self] user in
                self?.user = user
                if let user {
                    self?.name = "\(user.firstName) \(user.lastName)"
                }
            })
            .store(in: &cancellables)
    }
    
    func uploadItem() {
        
    }
    
    func tradeHistoryTapped() {
        tradeHistoryIsActive = true
    }
    
    func restorePurchaseTapped() {
        restorePurchaseIsActive = true
    }
    
    func paymentMethodTapped() {
        
    }
    
    func balanceTapped() {
        
    }
    
    func helpTapped() {
        helpIsActive = true
    }
    
    func logOutTapped() {
        logOutIsActive = true
    }
    
}
