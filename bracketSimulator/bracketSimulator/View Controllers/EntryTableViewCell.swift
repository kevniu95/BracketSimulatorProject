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
    @IBOutlet weak var lastPts: UILabel!
    
    @IBOutlet weak var completed: UILabel!
    @IBOutlet weak var simulationCt: UILabel!
    @IBOutlet weak var winnerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
