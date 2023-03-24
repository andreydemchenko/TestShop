//
//  SignInViewModel.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import Combine
import Foundation

class AuthViewModel: ObservableObject {
    private let authService: AuthService
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var firstNameError = ""
    @Published var lastNameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    
    @Published var authenticated = false
    @Published var errorMessage = ""
    @Published var showSignInPassword = false
    @Published var showSignUpPassword = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService) {
        self.authService = authService
        
        authService.userPublisher
            .map { $0 != nil }
            .assign(to: &$authenticated)
    }
    
    func validateFirstName() {
        if firstName.isEmpty && !authenticated {
            firstNameError = "First name is required"
        } else {
            firstNameError = ""
        }
    }
    
    func validateLastName() {
        if lastName.isEmpty && !authenticated {
            lastNameError = "Last name is required"
        } else {
            lastNameError = ""
        }
    }
    
    func validateEmail() {
        if !authenticated {
            if email.isEmpty {
                emailError = "Email is required"
            } else if !email.isValidEmail {
                emailError = "Please enter a valid email address"
            } else {
                emailError = ""
            }
        } else {
            emailError = ""
        }
            
    }
    
    func validatePassword() {
        if !authenticated {
            if password.isEmpty && !authenticated {
                passwordError = "Password is required"
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters long"
            } else {
                passwordError = ""
            }
        } else {
            passwordError = ""
        }
    }
    
    func validateInputFields() -> Bool {
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePassword()
        
        return firstNameError.isEmpty && lastNameError.isEmpty && emailError.isEmpty && passwordError.isEmpty
    }
    
    func toggleShowSignUpPassword() {
        showSignUpPassword.toggle()
    }
    
    func toggleShowSignInPassword() {
        showSignInPassword.toggle()
    }
    
    func clearFields() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
    }
    
    func clearErrors() {
        firstNameError = ""
        lastNameError = ""
        emailError = ""
        passwordError = ""
        errorMessage = ""
    }
    
    func signUp() {
        authService.signUp(email: email,
                           password: password,
                           firstName: firstName,
                           lastName: lastName)
        .sink(receiveCompletion: { [weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                self.clearFields()
            case .failure(let error):
                print(error.localizedDescription)
                self.$errorMessage
                    .sink { value in
                        DispatchQueue.main.async {
                            switch error {
                            case .userNotFound: break
                            case .userAlreadyExists:
                                self.errorMessage = "User has already registered with this email!"
                            case .databaseError:
                                self.errorMessage = "Database error"
                            }
                        }
                    }
                    .store(in: &self.cancellables)
            }
        }, receiveValue: { _ in})
        .store(in: &cancellables)
    }
    
    func signIn() {
        authService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.clearFields()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.$errorMessage
                        .sink { value in
                            DispatchQueue.main.async {
                                switch error {
                                case .userNotFound:
                                    self.errorMessage = "Incorrect email or password!"
                                case .userAlreadyExists: break
                                case .databaseError:
                                    self.errorMessage = "Database error"
                                }
                            }
                        }
                        .store(in: &self.cancellables)
                }
            }, receiveValue: { _ in})
            .store(in: &cancellables)
    }
    
    func signOut() {
        authService.signOut()
    }
    
}
