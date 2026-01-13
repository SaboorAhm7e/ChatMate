//
//  ProfileVC.swift
//  ChatMate
//
//  Created by saboor on 13/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct UserFirebaseModel {
    let userid : String
    let photoURL : String
    let email : String
    let age : Int
    let created : Timestamp?
    
    init?(document:DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.userid = data["userid"] as? String ?? ""
        self.photoURL = data["photoURL"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.age = data["age"] as? Int ?? 0
        self.created = data["created"] as? Timestamp
    }
}

class ProfileVC: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
           await printUser()
        }
        
        
    }
    func printUser() async {
        guard let user = Auth.auth().currentUser else { return }

        do {
            let db = Firestore.firestore()
            let snapshot = try await db
                .collection("users")
                .document(user.uid)
                .getDocument()
            
            guard let userModel = UserFirebaseModel(document: snapshot) else {
                return
            }

            emailField.text = userModel.email
            ageField.text = "\(userModel.age)"

        } catch {
            print("Error getting user:", error.localizedDescription)
        }
    }



}
