//
//  AuthDatabaseManager.swift
//  TestStorik
//
//  Created by andreydem on 13.03.2023.
//

import Foundation
import RealmSwift
import Combine

class DatabaseManager {
    
    private let realm = try! Realm()
    
    func save(user: User) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                try self.realm.write {
                    let userObject = user.toUserObject()
                    self.realm.add(userObject)
                    promise(.success(()))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func getUser(byEmail email: String) -> AnyPublisher<User?, Error> {
        return Future { promise in
            if let user = self.realm.objects(UserObject.self).filter("email == %@", email).first.map(User.init(userObject: )) {
                promise(.success(user))
            } else {
                promise(.failure(NSError(domain: "AuthDatabaseManager", code: 404)))
            }
        }.eraseToAnyPublisher()
    }
    
    func getUser(byId id: String) -> AnyPublisher<User?, Error> {
        return Future { promise in
            if let user = self.realm.object(ofType: UserObject.self, forPrimaryKey: id).map(User.init(userObject: )) {
                promise(.success(user))
            } else {
                promise(.failure(NSError(domain: "AuthDatabaseManager", code: 404)))
            }
        }.eraseToAnyPublisher()
    }
    
}
