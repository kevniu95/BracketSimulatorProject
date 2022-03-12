//
//  EntryTableViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class EntryTableViewController: UITableViewController {
//    var entryDict: [String: BracketEntry] = [:]
    var entryArray = [BracketEntry]()
//    var currentEntry: BracketEntry?
        
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
            initSheet()
        }
    }
    
    func initNewButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(objcInitSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func instantiateBracketEntries(){
        let bracketEntries = DataManager.sharedInstance.unArchiveEntries()
        entryArray = Array(bracketEntries.values)
    }
    
    func updateArrayForTable(){
        // Run to keep Table array up-to-date with "source-of-truth" stored
        // in DataManger
        let bracketEntries = DataManager.sharedInstance.bracketEntries
        entryArray = Array(bracketEntries.values)
        self.tableView.reloadData()
    }
    
    @objc func objcInitSheet(){
        initSheet()
    }
    
    func initSheet(){
        let requestNameVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestNameViewController") as! RequestNameViewController
        requestNameVC.delegate = self
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
        // Configure the cell...
        cell?.bracketName.text = entryArray[indexPath.row].name

        
        var avg: String
        if entryArray[indexPath.row].simulations > 0{
            avg = String(entryArray[indexPath.row].aggScore / entryArray[indexPath.row].simulations)
            
            
        }
        else{
            avg = "--"
        }
        cell?.winnerName.text = entryArray[indexPath.row].winner
        cell?.lastPts.text = "Average:\n" + avg + " / 1920"
        cell?.simulationCt.text = "\(entryArray[indexPath.row].simulations) simulations"
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
