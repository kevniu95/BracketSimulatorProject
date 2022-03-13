//
//  EntryTableViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class EntryTableViewController: UITableViewController {
    var entryArray = [BracketEntry]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.instantiateFixedData()
        initNewButton()
        instantiateBracketEntries()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        updateArrayForTable()
        if entryArray.count == 0{
            initSheet(copy: false, copyOf: nil)
        }
    }
    
    func initNewButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(objcInitSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    
    // MARK: Coordinate Table-Wide Data
    // Create Bracket Entries at very start
    func instantiateBracketEntries(){
        let bracketEntries = DataManager.sharedInstance.unArchiveEntries()
        entryArray = Array(bracketEntries.values)
    }
    
    // Keep table array updated
    func updateArrayForTable(){
        let bracketEntries = DataManager.sharedInstance.bracketEntries
        entryArray = Array(bracketEntries.values)
        self.tableView.reloadData()
    }
    
    // MARK: Handle initialization of new bracket entries
    @objc func objcInitSheet(copy: Bool, copyOf: BracketEntry?){
        initSheet(copy: copy, copyOf: copyOf)
    }
    
    func initSheet(copy: Bool, copyOf: BracketEntry?){
        let requestNameVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestNameViewController") as! RequestNameViewController
        requestNameVC.delegate = self
        if copy{
            requestNameVC.copy = copy
            requestNameVC.copyOf = copyOf
        }
        if let sheet = requestNameVC.sheetPresentationController{
            sheet.detents = [.large()]
        }
        present(requestNameVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as? EntryTableViewCell
        
        // 1. Bracket Name:
        let thisBracketEntry = entryArray[indexPath.row]
        cell?.bracketName.text = thisBracketEntry.name
        cell?.bracketName.textAlignment = .left
        
        // 2. Average Score
        var avg: String
        if thisBracketEntry.simulations > 0{
            avg = String(thisBracketEntry.aggScore / thisBracketEntry.simulations)
        } else{avg = "--"}
        cell?.lastPts.text = "Avg: " + avg + " / 1920"
        
        // 3. Determine winner and winner image
        let winnerIndex = thisBracketEntry.chosenTeams[0]
        var winnerImg: UIImage
        if winnerIndex > -1 {
            winnerImg = DataManager.sharedInstance.teams[winnerIndex].image
        }
        else{
            winnerImg = UIImage(systemName: "building.columns.circle")!
        }
        cell?.winnerImage.image = winnerImg
        cell?.winnerName.text = entryArray[indexPath.row].winner
        
        // 4. Function to run for copy button
        cell?.getRequestNameVC = {
            self.initSheet(copy: true, copyOf: self.entryArray[indexPath.row])
        }
        
        // 5. Lock Status Button
        if thisBracketEntry.completed{
            cell?.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
            if thisBracketEntry.locked{
                cell?.lockButton.isEnabled = false
            } else {cell?.lockButton.isEnabled = true}
        }
        else{
            cell?.lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
            cell?.lockButton.isEnabled = false
        }
        cell?.handleLock = {self.setLockButton(bracketEntry: thisBracketEntry)}
        
        // 5. Simulation results
        var simText: String
        if (entryArray[indexPath.row].simulations) > 9999{
            simText = ">9,999"
        } else {simText = DataManager.sharedInstance.formatInt(val:entryArray[indexPath.row].simulations)}
        cell?.simulationCt.text = "Simulations: \(simText)"
        return cell!
    }
    
    // Load already-saved bracket entry from table cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fillBracketSegue"{
            let bracketEntry =  entryArray[tableView.indexPathForSelectedRow!.row]
            if let newEntryVC = segue.destination as? NewEntryViewController{
                newEntryVC.inputBracketEntry = bracketEntry
                newEntryVC.delegate = self
            }
        }
    }
    
    // MARK: Other Table View stuff
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let theEntry = entryArray[indexPath.row]
            DataManager.sharedInstance.removeFromEntries(bracketEntry: theEntry)
            entryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func setLockButton(bracketEntry: BracketEntry){
        if !bracketEntry.completed || bracketEntry.locked{
            print("This should not be happening, double check.")
            return
        }
        let alert = UIAlertController(title: "Permanently lock this entry from editing?", message: "Only locked entries can be scored, but you can always make a new copy.", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            bracketEntry.lockBracket()
            DataManager.sharedInstance.updateEntries(entryName: bracketEntry.name, bracketEntry: bracketEntry)
            self.updateArrayForTable()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
        
    
}

extension EntryTableViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        updateArrayForTable()
    }
}

extension EntryTableViewController: RequestNameVCDelegate{
    func saveNewEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        updateArrayForTable()
    }
}
