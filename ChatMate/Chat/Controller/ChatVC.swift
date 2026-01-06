//
//  ChatVC.swift
//  ChatMate
//
//  Created by saboor on 27/12/2025.
//

import UIKit
import FirebaseAnalytics

nonisolated
struct Message: Hashable,Sendable {
    let isSender : Bool
    let message : String
}

class ChatVC: UIViewController {
    
    var image : String = ""
    var name : String = ""
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var messeageInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputView: MessageInputView!
    
    var data : [Message] = [
        .init(isSender: false, message: "Hello"),
        .init(isSender: true, message: "hi!"),
        .init(isSender: false, message: "how are you"),
        .init(isSender: true, message: "i am good!  whats about you"),
        .init(isSender: false, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    ]
    
    var dataSource : UITableViewDiffableDataSource<String,Message>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("ChatVC", parameters: nil)

        setUpNavigationBar()
        table.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 60
        configureDatasource()
        createSnapshot()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messageInputView.sendCompletion = { msg in
            print("msg: \(msg)")
            let model = Message(isSender: false, message: msg)
            self.data.append(model)
            self.createSnapshot()
        }
    }
    func setUpNavigationBar() {

        let containerView = UIView()

        // profile image
        let imageView  = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 2),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        navigationItem.titleView = containerView
    }
    func configureDatasource() {
        dataSource = UITableViewDiffableDataSource<String,Message>(tableView: table, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else {
                return UITableViewCell()
            }
            cell.configure(msg: itemIdentifier)
            return cell
        })
    }
    func createSnapshot(animatingDifference: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String, Message>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(data, toSection: "main")
        dataSource.apply(snapshot)
    }
    
    @objc func keyboardShow(_ notification : Notification) {
        

           if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
               print("Keyboard height:", frame.height)
               let bottomSafeArea = self.view.safeAreaInsets.bottom
               messeageInputViewBottomConstraint.constant = frame.height - bottomSafeArea
           }
    }
    @objc func keyboardHide(_ notification : Notification) {
        messeageInputViewBottomConstraint.constant = 0
    }

}
