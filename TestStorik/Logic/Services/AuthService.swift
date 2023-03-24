//
//  AuthService.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import Combine
import Foundation
import SwiftKeychainWrapper

class AuthService {
    
    private let keychainWrapper = KeychainWrapper.standard
    private let userDataStore = DatabaseManager()
    let userSubject = CurrentValueSubject<User?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getUserData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error getting userdata: \(error)")
                    self.userSubject.send(nil)
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.userSubject.send(user)
            })
            .store(in: &self.cancellables)
    }
    
    var userPublisher: AnyPublisher<User?, Never> {
        return userSubject.eraseToAnyPublisher()
    }
    
    private func checkUserIfExist(email: String) -> Future<Void, AuthError> {
        return Future { promise in
            self.userDataStore.getUser(byEmail: email)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(_):
                        promise(.success(()))
                    case .finished:
                        break
                    }
                }, receiveValue: { _ in
                    promise(.failure(.userAlreadyExists))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<Void, AuthError> {
        return checkUserIfExist(email: email)
            .mapError { error in
                return error
            }
            .flatMap { _ -> AnyPublisher<Void, AuthError> in
                self.registerUser(email: email, password: password, firstName: firstName, lastName: lastName)
            }
            .eraseToAnyPublisher()
    }
    
    private func registerUser(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<Void, AuthError> {
        let userId = UUID().uuidString
        keychainWrapper.set(userId, forKey: "userIdentifier")
        let user = User(userId: userId,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password)
        
        return Future { promise in
            self.userDataStore.save(user: user)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error saving user: \(error.localizedDescription)")
                        self.userSubject.send(nil)
                        promise(.failure(.databaseError))
                    case .finished:
                        break
                    }
                }, receiveValue: { _ in
                    self.userSubject.send(user)
                    promise(.success(()))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, AuthError> {
        return Future { promise in
            self.userDataStore.getUser(byEmail: email)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(_):
                        self.userSubject.send(nil)
                        promise(.failure(.userNotFound))
                    case .finished:
                        break
                    }
                }, receiveValue: { user in
                    if let user, password == user.password {
                        self.userSubject.send(user)
                        self.keychainWrapper.set(user.userId, forKey: "userIdentifier")
                        promise(.success(()))
                    } else {
                        self.userSubject.send(nil)
                        promise(.failure(.userNotFound))
                    }
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() {
        userSubject.send(nil)
        keychainWrapper.removeObject(forKey: "userIdentifier")
    }
    
    func getUserFromKeychain() -> String? {
        return keychainWrapper.string(forKey: "userIdentifier")
    }
    
    func getUserData() -> AnyPublisher<User?, AuthError> {
        guard let userId = getUserFromKeychain() else {
            return Future { promise in
                promise(.failure(.userNotFound))
            }.eraseToAnyPublisher()
        }
        return Future { promise in
            self.userDataStore.getUser(byId: userId)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(_):
                        promise(.failure(.userNotFound))
                    case .finished:
                        break
                    }
                }, receiveValue: { user in
                    promise(.success(user))
                })
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

enum AuthError: Error {
    case userNotFound
    case userAlreadyExists
    case databaseError
}
