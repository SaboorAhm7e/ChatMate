//
//  MessageInputView.swift
//  ChatMate
//
//  Created by saboor on 30/12/2025.
//

import UIKit

class MessageInputView: UIView , UITextViewDelegate {

    
    private lazy var inputField : UITextView = {
        let ip = UITextView()
        ip.translatesAutoresizingMaskIntoConstraints = false
        ip.text = "type something.."
        ip.textColor = .gray
        ip.layer.borderColor = UIColor.gray.cgColor
        ip.layer.borderWidth = 0.5
        ip.layer.cornerRadius = 5
        ip.font = UIFont.systemFont(ofSize: 16)
        ip.isScrollEnabled = false
        return ip
    }()
    
    private lazy var sendBtn : UIButton = {
        var config : UIButton.Configuration = .borderedProminent()
        config.image = UIImage(systemName: "arrow.forward")
        let btn = UIButton(configuration: config)
        btn.tintColor = UIColor.systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendTap), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shadowView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        return view
    }()
    
    private var tvHeightConstraint : NSLayoutConstraint!
    
    
    
    var sendCompletion : ((String) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        self.addSubview(shadowView)
        self.addSubview(inputField)
        self.addSubview(sendBtn)
        inputField.delegate = self
        
        tvHeightConstraint = inputField.heightAnchor.constraint(equalToConstant: 35)
        
        NSLayoutConstraint.activate([
            
            shadowView.topAnchor.constraint(equalTo: self.topAnchor,constant: -1),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 1),
            
            inputField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16),
            inputField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            inputField.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -7),
            
            sendBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sendBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            sendBtn.heightAnchor.constraint(equalToConstant: 32),
            sendBtn.widthAnchor.constraint(equalToConstant: 32),
            
            inputField.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -10)
            
        ])
        tvHeightConstraint.isActive = true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "type something.." {
            textView.text = ""
            textView.textColor = .black
        } else if textView.text == "" {
            textView.text = "type something.."
            textView.textColor = .gray
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != tvHeightConstraint.constant  {
                tvHeightConstraint.constant = size.height
            
        }
    }
    
    @objc
    func sendTap() {
        inputField.resignFirstResponder()
        if !inputField.text.isEmpty {
            let message = inputField.text ?? ""
            inputField.text = "type something.."
            inputField.textColor = .gray
            self.sendCompletion!(message)
        }
        
       
    }
    
    
    
}
