//
//  EntryTableViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

// Resource referenced for creating table sections
// https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/grouping-sections/


// Create struct and enum to manage bracket status (sections in table)
struct StatusSection {
    var status: Status
    var bracketEntries: [BracketEntry]
    var statusName: String
}

enum Status: Int{
    case locked = 1, ready, incomplete
    
    func getString() -> String{
        switch self{
        case.locked:
            return "Locked"
        case.ready:
            return "Ready to lock"
        case.incomplete:
            return "Incomplete"
        }
    }
}


class EntryTableViewController: UITableViewController {
    var entryArray = [BracketEntry]()
    var sections = [StatusSection]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.instantiateFixedData()
        initNewButton()
        initInstrButton()
        manageTimesOpened(timesOpened: DataManager.sharedInstance.timesOpened)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        updateArrayAndSections()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)        

        if entryArray.count == 0{
            initSheet(copy: false, copyOf: nil)
        }
    }
    
    // MARK: Manage times opened and basic buttons
    func manageTimesOpened(timesOpened: Int){
        if timesOpened == 3{
            askForRating()
        }
        print("I am managing how many times this thing was opened, which was \(timesOpened)")
    }
    
    func initNewButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(objcInitSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func initInstrButton(){
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(objcInitInstructions))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func objcInitInstructions() {
        initInstructions()
    }
    
    func initInstructions(){
        let instructionVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
        if let sheet = instructionVC.sheetPresentationController{
            sheet.detents = [.large()]
        }
        present(instructionVC, animated: true, completion: nil)
    }
    
    // MARK: Coordinate Table-Wide Data
    // Keep table array updated
    func updateArrayForTable(){
        let bracketEntries = DataManager.sharedInstance.bracketEntries
        entryArray = Array(bracketEntries.values)
    }

    func establishSections(){
        let groups = Dictionary(grouping: self.entryArray){ (entry) in
            return getEntryStatus(entry: entry)
        }
        self.sections = groups.map{(key, values) in
            return StatusSection(status: key, bracketEntries: values, statusName: key.getString())
        }
    }
    
    func getEntryStatus(entry: BracketEntry) -> Status {
        if entry.locked{
            return Status.locked
        }
        else if entry.completed{
            return Status.ready
        }
        else{return Status.incomplete}
    }

    // Now add function that updates array as well as updates sections
    func updateArrayAndSections(){
        print("The entire table has undergone an update!")
        updateArrayForTable()
        establishSections()
        self.sections.sort{(lhs, rhs) in lhs.status.rawValue < rhs.status.rawValue}
        self.sortEntriesInSection()
        self.tableView.reloadData()
    }
    
    func sortEntriesInSection(){
        print("I am sorting the entries in each section")
        if self.sections.count > 0{
            for i in 0...(self.sections.count - 1){
                if self.sections[i].status.getString() == "Locked"{
                    self.sections[i].bracketEntries.sort{(lhs, rhs) in lhs.lockDate! > rhs.lockDate!}
                } else{
                    self.sections[i].bracketEntries.sort{(lhs, rhs) in lhs.lastEdit > rhs.lastEdit}
                }
            }
        }
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
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.statusName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.bracketEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as? EntryTableViewCell
        let section = self.sections[indexPath.section]
        
        // 1. Bracket Name:
        let thisBracketEntry = section.bracketEntries[indexPath.row]
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
        cell?.winnerName.text = thisBracketEntry.winner

        // 4. Function to run for copy button
        cell?.getRequestNameVC = {
            self.initSheet(copy: true, copyOf: thisBracketEntry)
        }

        // 5. Lock Status Button
        if thisBracketEntry.completed{
            cell?.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
            if thisBracketEntry.locked{
                cell?.lockButton.isEnabled = false
            } else {cell?.lockButton.isEnabled = true}
        }
        else{
            cell?.lockButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            cell?.lockButton.isEnabled = true
        }
        cell?.handleLock = {self.setLockButton(bracketEntry: thisBracketEntry)}

        
        var simText: String
        if (entryArray[indexPath.row].simulations) > 999999 {
            simText = ">999,999"
        } else {simText = DataManager.sharedInstance.formatInt(val: thisBracketEntry.simulations)}
        cell?.simulationCt.text = "Simulations: \(simText)"
        return cell!
    }
    
    // Load already-saved bracket entry from table cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let thisIndPath = tableView.indexPathForSelectedRow
        let section = self.sections[thisIndPath!.section]
        let thisBracketEntry = section.bracketEntries[thisIndPath!.row]
        if segue.identifier == "detailViewSegue"{
            let bracketEntry = thisBracketEntry
            print("Going from table to detailed cell!")
            print("The winner selected for the entry at this cell was: \(bracketEntry.winner)")
            if let newEntryVC = segue.destination as? EntryDetailViewController{
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
            let section = self.sections[indexPath.section]
            let theEntry = section.bracketEntries[indexPath.row]
            DataManager.sharedInstance.removeFromEntries(bracketEntry: theEntry)
            self.sections[indexPath.section].bracketEntries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: Misc
    func askForRating(){
        let alert = UIAlertController(title: "Rate us on the App Store!", message: "If you're enjoying this app, please rate us on the App Store!", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
            if (DataManager.sharedInstance.bracketEntries).count == 0{
                self.initSheet(copy: false, copyOf: nil)
            }}))
        
        self.present(alert, animated: true)
    }
    
    // MARK: Define lock button functionality
    func setLockButton(bracketEntry: BracketEntry){
        if !bracketEntry.completed {
            let newEntryVC = self.storyboard?.instantiateViewController(withIdentifier: "NewEntryViewController") as! NewEntryViewController
            newEntryVC.delegate = self
            newEntryVC.inputBracketEntry = bracketEntry
            present(newEntryVC, animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Permanently lock this entry from editing?", message: "Only locked entries can be scored, but you can always make a new copy.", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            bracketEntry.lockBracket()
            DataManager.sharedInstance.updateEntries(entryName: bracketEntry.name, bracketEntry: bracketEntry)
            self.updateArrayAndSections()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}


// MARK: Act as Delegate
extension EntryTableViewController: EntryDetailVCDelegate{
    func saveDetailEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        updateArrayAndSections()
    }
}

extension EntryTableViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        updateArrayAndSections()
    }
}

extension EntryTableViewController: RequestNameVCDelegate{
    func saveNewEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        updateArrayAndSections()
    }
}
