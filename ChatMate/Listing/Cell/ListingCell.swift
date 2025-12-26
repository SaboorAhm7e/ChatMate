//
//  ListingCell.swift
//  ChatMate
//
//  Created by saboor on 26/12/2025.
//

import UIKit

class ListingCell: UITableViewCell {
    
    
    static let identifier = "ListingCell"
    static let nib = UINib(nibName: "ListingCell", bundle: nil)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBOutlet weak var personImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        personImage.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model : ListingModel){
        nameLabel.text = model.name
        messageLabel.text = model.message
        personImage.image = UIImage(named: model.image)
    }
    
}
