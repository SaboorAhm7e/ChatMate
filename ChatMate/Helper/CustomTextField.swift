//
//  CustomTextField.swift
//  ChatMate
//
//  Created by saboor on 25/12/2025.
//

import UIKit

@IBDesignable
class CustomTextField : UITextField {
    @IBInspectable
    var corner : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = corner
        }
    }
    @IBInspectable
    var borderLine : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderLine
        }
    }
    @IBInspectable
    var boderColor : UIColor?  {
        didSet {
            self.layer.borderColor = boderColor?.cgColor
        }
    }
    @IBInspectable
    var bg : UIColor? {
        didSet {
            self.backgroundColor = bg
        }
    }
    // left padding
    @IBInspectable
    var leftPadding : CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0))
    }
    
}
