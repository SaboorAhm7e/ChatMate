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

class ProfileVC: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    var genderIndex : Int = 2
    
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

            firstNameField.text = userModel.firstName
            lastNameField.text = userModel.lastName
            emailField.text = userModel.email
            segmentControl.selectedSegmentIndex = userModel.genderIndex
            genderIndex = userModel.genderIndex
            

        } catch {
            print("Error getting user:", error.localizedDescription)
        }
    }
    
    
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        genderIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func editBtnTap(_ sender: Any) {
        
        guard let firstName = firstNameField.text,!firstName.isEmpty,let lastName = lastNameField.text,!lastName.isEmpty else {
            return
        }
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        var gender = ""
        switch genderIndex {
        case 0:
            gender = "M"
        case 1:
            gender = "F"
        default:
            gender = "N"
        }
        let updatedData : [String:Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "gender": gender
            
        ]
        
        db.collection("users").document(user.uid).updateData(updatedData) { err in
            if let error = err {
                print("error updating data")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
    }
    

}
