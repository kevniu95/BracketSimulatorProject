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
    
    @IBOutlet weak var frameContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var frameContentView: UIView!
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
    
    @IBOutlet weak var simTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        simTable.delegate = self
        simTable.dataSource = self
        simTable.isScrollEnabled = false
        scrollView.contentSize.height = CGFloat(500)
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setBracketEntry()
        setImages()
        setText()
        setScrollHeight()
        
    }
    
    func setScrollHeight(){
        frameContentViewHeight.constant = CGFloat((bracketEntry.recentSims.count * 65) + 640)
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
            print("I am entering from the actual entry")
            let bracketEntry =  thisBracketEntry
            if let newEntryVC = segue.destination as? NewEntryViewController{
                newEntryVC.inputBracketEntry = bracketEntry
                newEntryVC.delegate = self
            }
        }
        if segue.identifier == "showBracketFromSim"{
            print("I am entering from simulations")
            let bracketEntry =  thisBracketEntry
            guard let thisRow = simTable.indexPathForSelectedRow?.row else {
                print("Couldn't find selected row in table!")
                return
            }
            let thisSimInfo = bracketEntry.recentSims[thisRow]
            if let newEntryVC = segue.destination as? NewEntryViewController{
                newEntryVC.inputBracketEntry = bracketEntry
                newEntryVC.delegate = self
                newEntryVC.simulationResults = thisSimInfo
            }
        }
    }
//    let thisBracketEntry = section.bracketEntries[thisIndPath!.row]
//    if segue.identifier == "detailViewSegue"{
//        let bracketEntry = thisBracketEntry
//        print("Going from table to detailed cell!")
//        print("The winner selected for the entry at this cell was: \(bracketEntry.winner)")
//        if let newEntryVC = segue.destination as? EntryDetailViewController{
//            newEntryVC.inputBracketEntry = bracketEntry
//            newEntryVC.delegate = self
    
    
}

extension EntryDetailViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry) {
        delegate?.saveDetailEntry(entryName: entryName, entry: entry)
    }
}


extension EntryDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(bracketEntry.recentSims.count)
        return bracketEntry.recentSims.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simTableViewCell", for: indexPath) as? SimTableViewCell
        cell?.simulationName.text = "Simulation #\(indexPath.row + 1)"
        let thisSimInfo = bracketEntry.recentSims[indexPath.row]
        let thisScore = bracketEntry.justGetScores(simulationResultInts: thisSimInfo)
        
        cell?.simulationScore.text = "\(thisScore)"
        
        let finalFourTeams = determineFinalFour(recentSimResults: bracketEntry.recentSims[indexPath.row])
        assignPicsLabels(finalFourTeams: finalFourTeams, cell: cell)

        
        if thisScore > 650{
            cell?.backgroundColor = .systemGreen.withAlphaComponent(0.25)
            
        }
        else if thisScore < 350{
            cell?.backgroundColor = .systemRed.withAlphaComponent(0.3)
        }
        else{
            cell?.backgroundColor = .systemGray6
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    func determineFinalFour(recentSimResults: [Int]) -> [Int]{
        var finalFourIndices = [Int]()
        let winner = recentSimResults[0]
        var runnerUp: Int
        if recentSimResults[1] == winner{
            runnerUp = recentSimResults[2]
        } else{
            runnerUp = recentSimResults[1]
        }
        finalFourIndices.append(winner)
        finalFourIndices.append(runnerUp)
        for i in 3...6{
            if !finalFourIndices.contains(recentSimResults[i]){
                finalFourIndices.append(recentSimResults[i])
            }
        }
        return finalFourIndices
    }
    
    func getImage(teamIndex: Int) -> UIImage{
        var winnerImg: UIImage
        if teamIndex > -1 {
            winnerImg = DataManager.sharedInstance.teams[teamIndex].image
        }
        else{
            winnerImg = UIImage(systemName: "building.columns.circle")!
        }
        return winnerImg
    }
    
    func assignPicsLabels(finalFourTeams: [Int], cell: SimTableViewCell?){
        let winner = getImage(teamIndex: finalFourTeams[0])
        let runnerUp = getImage(teamIndex: finalFourTeams[1])
        
        let semi1 = getImage(teamIndex: finalFourTeams[2])
        let semi2 = getImage(teamIndex: finalFourTeams[3])
        
        cell?.pic1.image = winner
        cell?.pic2.image = runnerUp
        cell?.pic3.image = semi1
        cell?.pic4.image = semi2
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if bracketEntry.locked {
            let headerView = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: tableView.frame.width, height: 50))
            
            headerView.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            
            headerView.text = "Last 50 Simulation Results"
            
            return headerView
        }
        else{ return nil }
    
}
}
