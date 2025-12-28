//
//  ChatCell.swift
//  ChatMate
//
//  Created by saboor on 27/12/2025.
//

import UIKit

class ChatCell: UITableViewCell {

    static let identifier = "ChatCell"
    
    lazy var bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        
        return view
    }()
    
    lazy var personImage : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:00 PM"
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    lazy var messageStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private var leadingConstraint : NSLayoutConstraint!
    private var trailingConstraint : NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        self.selectionStyle = .none
        //contentView.addSubview(messageStack)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageStack)
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
           
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            
            messageStack.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            messageStack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            messageStack.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageStack.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
        ])
        messageStack.addArrangedSubview(messageLabel)
        messageStack.addArrangedSubview(timeLabel)
        
    }
    
    func configure(msg: Message) {

        messageLabel.text = msg.message
        if msg.isSender {
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
            bubbleView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
            messageStack.alignment = .trailing
            timeLabel.textColor = .white
        } else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            bubbleView.backgroundColor = UIColor.systemGray4
            messageLabel.textColor = .label
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
            messageStack.alignment = .leading
            timeLabel.textColor = .secondaryLabel
        }
    }
    
}
