//
//  VCFactory.swift
//  ChatMate
//
//  Created by saboor on 07/01/2026.
//

import Foundation
import UIKit


enum VCType {
    case auth
    case listing
    
}
final class VCFactory {
    static func makeRootVC() -> UIViewController {
        
        
        
        if DataManager.shared.isAuthenticate {
            
            return UINavigationController(rootViewController: ListingVC())
        } else {
            return AuthVC()
        }
        
    }
}

