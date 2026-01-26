//
//  ListingChatsCell.swift
//  ChatMate
//
//  Created by saboor on 18/01/2026.
//

import UIKit

class ListingChatsCell: UITableViewCell {

    static let identifier = "ListingChatsCell"
    static let nib : UINib = UINib(nibName: "ListingChatsCell", bundle: nil)
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
