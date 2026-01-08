//
//  SettingVC.swift
//  ChatMate
//
//  Created by saboor on 07/01/2026.
//

import UIKit
import FirebaseAuth

enum ProvidedLanguage: String {
    case en = "English"
    case ur = "Urdu"
}

class SettingVC: UIViewController {
    
    var currentLanguage : ProvidedLanguage = .en

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageMenuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Settings"
    
        languageMenuBtn.showsMenuAsPrimaryAction = true
        
        let english = UIAction(title: "English") {  _ in
            self.currentLanguage = .en
            self.languageLabel.text = self.currentLanguage.rawValue
        }
        let urdu = UIAction(title: "Urdu") { _ in
            self.currentLanguage = .ur
            self.languageLabel.text = self.currentLanguage.rawValue
        }
        
        languageMenuBtn.menu = UIMenu(children: [english,urdu]
        )
    }
    @IBAction func darkModeToggle(_ sender: UISwitch) {
        
    }
    
    @IBAction func singOutTap(_ sender: Any) {
        
        do {
           try  Auth.auth().signOut()
            DataManager.shared.isAuthenticate = false
            let rootVC = VCFactory.makeRootVC()
            UIApplication.sceneDelegate?.setRootVC(rootVC, animated: true)
        } catch {
            print("sign out failed : \(error.localizedDescription)")
        }
        
        
        
    }
}
