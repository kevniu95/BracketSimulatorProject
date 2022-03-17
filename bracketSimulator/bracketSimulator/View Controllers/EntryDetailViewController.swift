//
//  EntryDetailViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/13/22.
//

import UIKit

class EntryDetailViewController: UIViewController {
   
    var delegate: EntryTableViewController?
    weak var inputBracketEntry: BracketEntry?
    var bracketEntry = BracketEntry(name: "")
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topLeft: UIImageView!
    @IBOutlet weak var topRight: UIImageView!
    @IBOutlet weak var bottomLeft: UIImageView!
    @IBOutlet weak var bottomRight: UIImageView!
    
    @IBOutlet weak var entryName: UILabel!
    @IBOutlet weak var totalSimulations: UILabel!
    @IBOutlet weak var averageScore: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var lockedOn: UILabel!
    @IBOutlet weak var goToBracket: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setBracketEntry()
        setImages()
        setText()
    }
    
    
    // MARK: Set up data for this bracket entry
    func setBracketEntry(){
        if let inputBracketEntry = inputBracketEntry{
            bracketEntry = inputBracketEntry
        } else {print("uhoh!")}
        DataManager.sharedInstance.setRecentDetailEntry(entry: bracketEntry)
    }

    func setText(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/d/YY"
        entryName.text = bracketEntry.name
        
        if bracketEntry.simulations == 0{
            totalSimulations.text = "Simulations run: --"
            averageScore.text = "Average Score: -- / 1960"
        }
        else{
            let sims = DataManager.sharedInstance.formatInt(val: bracketEntry.simulations)
            totalSimulations.text = "Simulations run: " + sims
            let avgScore = Int(Float(bracketEntry.aggScore) / Float(bracketEntry.simulations))
            let avgScoreText = DataManager.sharedInstance.formatInt(val: avgScore)
            averageScore.text = "Average Score: " + avgScoreText + " / 1960"
        }
        
        print("Showing summary for bracket entry created \(bracketEntry.initDate)")
        createdOn.text = "Created: " + dateformatter.string(from: bracketEntry.initDate)
        
        if bracketEntry.locked{
            lockedOn.text = "Locked: " + dateformatter.string(from: bracketEntry.lockDate!)
        }
        else{
            lockedOn.text = "Locked: --"
        }
    }

    func setImages(){
        let allTeams = DataManager.sharedInstance.shareTeams()
        if bracketEntry.chosenTeams[3] > -1{
            topLeft.image = allTeams[bracketEntry.chosenTeams[3]].image
        }
        if bracketEntry.chosenTeams[4] > -1{
            bottomLeft.image = allTeams[bracketEntry.chosenTeams[4]].image
        }
        if bracketEntry.chosenTeams[5] > -1{
            topRight.image = allTeams[bracketEntry.chosenTeams[5]].image
        }
        if bracketEntry.chosenTeams[6] > -1{
            bottomRight.image = allTeams[bracketEntry.chosenTeams[6]].image
        }
    }
    
    // MARK: Sets up go to bracket button
    func setUpButton(){
        goToBracket.titleLabel?.textAlignment = .center
        if bracketEntry.locked{
            goToBracket.alpha = 0.7
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let thisBracketEntry = bracketEntry
        if segue.identifier == "showBracket"{
            let bracketEntry =  thisBracketEntry
            if let newEntryVC = segue.destination as? NewEntryViewController{
                newEntryVC.inputBracketEntry = bracketEntry
                newEntryVC.delegate = self
            }
        }
    }
        

}

extension EntryDetailViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry) {
        delegate?.saveDetailEntry(entryName: entryName, entry: entry)
    }
}
