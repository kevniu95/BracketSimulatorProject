//
//  SimTableViewCell.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/20/22.
//

import UIKit

class SimTableViewCell: UITableViewCell {
    @IBOutlet weak var simulationName: UILabel!
    @IBOutlet weak var simulationScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
