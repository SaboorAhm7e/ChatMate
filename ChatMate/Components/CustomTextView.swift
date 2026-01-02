//
//  CustomTextView.swift
//  ChatMate
//
//  Created by saboor on 02/01/2026.
//

import UIKit

class CustomTextView: UITextView {

    var corner : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = corner
        }
    }
    
    var borderLine : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderLine
        }
    }
    
    var boderColor : UIColor?  {
        didSet {
            self.layer.borderColor = boderColor?.cgColor
        }
    }
    
    
}
