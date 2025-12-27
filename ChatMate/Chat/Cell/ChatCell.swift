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
        return view
    }()
    
    lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        contentView.addSubview(bubbleView)
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        bubbleView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5),
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
        ])
        
    }
    
    func configure(msg: Message) {
        bubbleView.removeFromSuperview()
        contentView.addSubview(bubbleView)
        if msg.isSender {
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                bubbleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
                bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
            bubbleView.backgroundColor = .blue.withAlphaComponent(0.7)
            messageLabel.textColor = .white
        } else {
            NSLayoutConstraint.activate([
                bubbleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
            bubbleView.backgroundColor = .gray.withAlphaComponent(0.5)
            messageLabel.textColor = .black
        }
        bubbleView.addSubview(messageLabel)
        messageLabel.text = msg.message
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5),
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
        ])
    }
    
}
