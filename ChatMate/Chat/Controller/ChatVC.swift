//
//  ChatVC.swift
//  ChatMate
//
//  Created by saboor on 27/12/2025.
//

import UIKit

nonisolated
struct Message: Hashable,Sendable {
    let isSender : Bool
    let message : String
}

class ChatVC: UIViewController {
    
    
    @IBOutlet weak var table: UITableView!
    
    let data : [Message] = [
        .init(isSender: false, message: "Hello"),
        .init(isSender: true, message: "hi!"),
        .init(isSender: false, message: "how are you"),
        .init(isSender: true, message: "i am good!  whats about you")
    ]
    
    var dataSource : UITableViewDiffableDataSource<String,Message>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        configureDatasource()
        createSnapshot()
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

}
