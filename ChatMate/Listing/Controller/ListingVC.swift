//
//  ListingVC.swift
//  ChatMate
//
//  Created by saboor on 26/12/2025.
//

import UIKit

@MainActor
class ListingVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    
    private var dataSource : UITableViewDiffableDataSource<String,ListingModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CEOs"
        self.navigationItem.largeTitleDisplayMode = .always
        setUpTable()
        configureDataSource()
        applySnapShot(animatingDifference: false)
        
    }

    private func setUpTable() {
        table.delegate = self
        table.register(ListingCell.nib, forCellReuseIdentifier: ListingCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<String,ListingModel>(tableView: table, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListingCell.identifier, for: indexPath) as? ListingCell else {
                return UITableViewCell()
            }
            cell.configure(model: itemIdentifier)
            return cell
        })
    }
    
    private func applySnapShot(animatingDifference : Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String,ListingModel>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(ListingModel.dummyData, toSection: "main")
        dataSource.apply(snapshot, animatingDifferences: animatingDifference)
        
    }

}
// MARK: - Cell Swipe
extension ListingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            print("Delete tapped for row \(indexPath.row)")
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
