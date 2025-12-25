//
//  AuthVC.swift
//  ChatMate
//
//  Created by saboor on 25/12/2025.
//

import UIKit

class AuthVC: UIViewController {

    // MARK: - properties
    var isSignUp : Bool = true
    
    // MARK: - outlets
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var secondaryBtn: UIButton!

    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpGradient()
        setUpUI()
        setUpMainBtn()

    }

    // MARK: UI
    func setUpGradient() {

        let isDark = traitCollection.userInterfaceStyle == .dark
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            isDark ?  UIColor.cmBlue.cgColor : UIColor.cmGreen.cgColor,
            UIColor.white.cgColor
        ]
        view.layer.insertSublayer(gradient, at: 0)

    }
    func setUpUI() {
        UIView.animate(withDuration: 0.2) {
            self.confirmPasswordField.isHidden = self.isSignUp ? false : true
        }
        
        forgotBtn.isHidden = isSignUp ? true : false
        bottomLabel.text = isSignUp ? "Already have an account?" : "Don't have an account?"
        secondaryBtn.setTitle(isSignUp ? "Log In" : "Create Account", for: .normal)
    }
    func setUpMainBtn() {
      mainBtn.layer.shadowColor = UIColor.black.cgColor
      mainBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
      mainBtn.layer.shadowRadius = 6
      mainBtn.layer.shadowOpacity = 0.3
      mainBtn.layer.masksToBounds = false
      mainBtn.clipsToBounds = false
    }
    

    
    // MARK: - action
    
    @IBAction func secondaryBtnTap(_ sender: Any) {
        isSignUp.toggle()
        setUpUI()
    }
    

}

