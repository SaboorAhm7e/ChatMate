//
//  ListingVC.swift
//  ChatMate
//
//  Created by saboor on 18/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Combine


class ListingVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    
    // MARK: - Properties
    var peopleListing : [UserModel] = []
    var chatListing : [ChatModel] = []
    
    var viewModel = FirebaseViewModel()
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation()
        setUpTable()
        fetchPeople()
        
    }
    private func setUpTable() {
        table.delegate = self
        table.dataSource = self
        table.register(ListingChatsCell.nib, forCellReuseIdentifier: ListingChatsCell.identifier)
        table.register(ListingPeopleCell.nib, forCellReuseIdentifier: ListingPeopleCell.identifier)
    }
    private func setUpNavigation() {
        let profileBtn = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(profileTap))
        self.navigationItem.rightBarButtonItem = profileBtn
    }
    @objc func profileTap() {
        self.navigationController?.pushViewController(ProfileVC(), animated: true)
    }

    // MARK: - Action
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            fetchPeople()
        } else {
            fetchChat()
        }
    }
    
    func fetchPeople() {
        viewModel.fetchPeople()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] users in
                self?.peopleListing = users
                self?.table.reloadData()
            }
            .store(in: &cancellable)

    }
    
    func fetchChat() {
        
        viewModel.fetchChats()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] chats in
                self?.chatListing = chats
                self?.table.reloadData()
            }
            .store(in: &cancellable)
    }

    
    func getPerson(members : [String],completion:@escaping (UserModel) -> Void)  {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        
        let otherid = members.first(where: {$0 != currentUserId}) ?? currentUserId
        

        viewModel.fetchUser(id: otherid)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { user in
               completion(user)
            }
            .store(in: &cancellable)
        
    }
    
}
// MARK: - Table Delegate
extension ListingVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentControl.selectedSegmentIndex == 0 ? peopleListing.count : chatListing.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListingPeopleCell.identifier, for: indexPath) as? ListingPeopleCell else {
                return UITableViewCell()
            }
            cell.nameLabel.text = peopleListing[indexPath.row].fullName
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListingChatsCell.identifier, for: indexPath) as? ListingChatsCell else {
                return UITableViewCell()
            }
            Task {
                
                getPerson(members: chatListing[indexPath.row].members) { user in
                    cell.nameLabel.text = user.fullName
                }
                
               
            }
            
            
            cell.messageLabel.text = chatListing[indexPath.row].lastMessage ?? ""
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex != 0 {
            let vc = ChatVC()
            let item = chatListing[indexPath.row]
            vc.chat = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
