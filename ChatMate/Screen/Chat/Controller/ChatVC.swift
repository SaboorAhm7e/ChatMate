//
//  ChatVC.swift
//  ChatMate
//
//  Created by saboor on 27/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics


class ChatVC: UIViewController {
    
    var image : String = ""
    var chat : ChatModel!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var messeageInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputView: MessageInputView!
    
    var messages : [MessageModel] = []
    
    var dataSource : UITableViewDiffableDataSource<String,MessageModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
        
        Analytics.logEvent("ChatVC", parameters: nil)

        setUpNavigationBar()
        table.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 60
        configureDatasource()
        createSnapshot()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messageInputView.sendCompletion = { [weak self] text in
            self?.sendMessage(text)
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
        Task {
            if let othePerson = await getPerson(members: chat!.members) {
                nameLabel.text = othePerson.fullName
            }
           
        }
        
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
        dataSource = UITableViewDiffableDataSource<String,MessageModel>(tableView: table, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else {
                return UITableViewCell()
            }
            cell.configure(msg: itemIdentifier)
            return cell
        })
    }
    func fetchMessages() {
        Firestore.firestore()
            .collection("chats")
            .document(chat.chatId)
            .collection("messages")
            .order(by: "time", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                
                guard let self = self else { return }
                guard let documents = snapshot?.documents else { return }
                
                self.messages = documents.compactMap {
                    MessageModel(document: $0)
                }
                
                self.createSnapshot()
                
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
    }

    func getPerson(members : [String]) async -> UserModel? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        
        let otherid = members.first(where: {$0 != currentUserId}) ?? currentUserId
        
        do {
            let snapshot = try await Firestore.firestore()
                                .collection("users")
                                .document(otherid)
                                .getDocument()
            
            if let userModel = UserModel(document: snapshot) {
                return userModel
            }

        } catch {
            print("error getting user :\(error.localizedDescription)")
            
        }
        return nil
        
    }
    func sendMessage(_ text: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Firestore.firestore()
            .collection("chats")
            .document(chat.chatId)
            .collection("messages")
            .document()
        
        let data: [String: Any] = [
            "senderId": uid,
            "text": text,
            "time": Timestamp()
        ]
        
        ref.setData(data)
        
        // update last message
        Firestore.firestore()
            .collection("chats")
            .document(chat.chatId)
            .updateData([
                "lastMessage": text,
                "lastMessageSender": uid,
                "lastMessageTime": Timestamp()
            ])
    }

    func createSnapshot(animatingDifference: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String, MessageModel>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(messages, toSection: "main")
        dataSource.apply(snapshot, animatingDifferences: animatingDifference)
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
