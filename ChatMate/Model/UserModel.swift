//
//  UserModel.swift
//  ChatMate
//
//  Created by saboor on 19/01/2026.
//

import Foundation
import FirebaseFirestore

struct UserModel {
    let userid : String
    let photoURL : String
    let email : String
    let gender : String
    let firstName : String
    let lastName : String
    
    var fullName : String {
        return firstName + " " + lastName
    }
    var genderIndex : Int {
        switch gender {
        case "M","m":
            return 0
        case "F","f":
            return 1
        default:
            return 2
        }
    }
    init?(document:DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.userid = data["uid"] as? String ?? ""
        self.photoURL = data["photoURL"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.gender = data["gender"] as? String ?? "N"
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
    }
}
