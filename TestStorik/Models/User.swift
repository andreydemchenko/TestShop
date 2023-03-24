//
//  User.swift
//  TestStorik
//
//  Created by andreydem on 11.03.2023.
//

import Foundation

struct User {
    var userId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
}

extension User {
    init(userObject: UserObject) {
        userId = userObject.id
        firstName = userObject.firstName
        lastName = userObject.lastName
        email = userObject.email
        password = userObject.password
    }
    
    func toUserObject() -> UserObject {
        let user = UserObject()
        user.id = userId
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.password = password
        return user
    }
}
