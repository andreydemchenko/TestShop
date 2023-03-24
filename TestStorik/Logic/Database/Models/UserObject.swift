//
//  UserObject.swift
//  TestStorik
//
//  Created by andreydem on 13.03.2023.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var profileImageUrl: String = ""
    @objc dynamic var balance: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
