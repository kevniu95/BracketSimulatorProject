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
    @IBOutlet weak var simulationCt: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var winnerName: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    // MARK: Cell set-up
    override func awakeFromNib() {
        super.awakeFromNib()
        copyButton.addTarget(self, action: #selector(handleCopyTap), for: UIControl.Event.touchUpInside)
        lockButton.addTarget(self, action: #selector(handleLockTap), for: UIControl.Event.touchUpInside)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: Cell Buttons
    // 1. Copy Button
    //https://stackoverflow.com/questions/62617968/add-button-to-uitableview-cell-programmatically
    var getRequestNameVC: () -> ()  = { }
    var handleLock: () -> ()  = { }
    @objc func handleCopyTap(){
        getRequestNameVC()
    }
    
    @objc func handleLockTap(){
        handleLock()
    }
    

}
