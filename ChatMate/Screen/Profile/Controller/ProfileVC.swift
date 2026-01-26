//
//  ProfileVC.swift
//  ChatMate
//
//  Created by saboor on 13/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Combine


class ProfileVC: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var cancellable = Set<AnyCancellable>()
    
    var viewModel = FirebaseViewModel()
    
    var genderIndex : Int = 2
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        picker.delegate = self
        
    }
    func fetchUser() {
        guard let userid = Auth.auth().currentUser else {
            return
        }
        viewModel.fetchUser(id: userid.uid)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                self?.firstNameField.text = user.firstName
                self?.lastNameField.text = user.lastName
                self?.emailField.text = user.email
                self?.segmentControl.selectedSegmentIndex = user.genderIndex
                self?.genderIndex = user.genderIndex
            }
            .store(in: &cancellable)


        
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
            if let _ = err {
                print("error updating data")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
    }
    
    @IBAction func didTapEditPhoto(_ sender: Any) {
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true)
    }
    
}
extension ProfileVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let original = info[.originalImage] as? UIImage {
            self.profileImage.image = original
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
