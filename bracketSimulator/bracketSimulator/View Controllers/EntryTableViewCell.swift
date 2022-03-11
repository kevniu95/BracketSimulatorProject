//
//  EntryTableViewCell.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var bracketName: UILabel!
    @IBOutlet weak var winnerSelected: UILabel!
    @IBOutlet weak var lastPts: UILabel!
    @IBOutlet weak var avgPts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
