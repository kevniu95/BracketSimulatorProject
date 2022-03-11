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
        initNewButton()
//        instantiateBracketEntries()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        instantiateBracketEntries()
//        setEntryArray()
        if entryArray.count == 0{
            initSheet()
        }
    }
    
    //Users/kniu91/Library/Developer/CoreSimulator/Devices/74A7AD40-7D35-43EE-8DCD-772AFA3588B9/data/Containers/Data/Application/9DA6A2C0-5FA5-4259-9346-895DBE105730/Documents/bracketEntries.plist
    
    func instantiateBracketEntries(){
        let bracketEntries = DataManager.sharedInstance.unArchiveEntries()
        entryArray = Array(bracketEntries.values)
    }
    
    func initNewButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(objcInitSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
        
    @objc func objcInitSheet(){
        initSheet()
    }

    func setEntryArray(){
        let bracketEntries = DataManager.sharedInstance.bracketEntries
        entryArray = Array(bracketEntries.values)
        print(entryArray)
        self.tableView.reloadData()
        DataManager.sharedInstance.archiveEntries()
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
        cell?.winnerSelected.text = entryArray[indexPath.row].winner
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
        return 50
    }
}

extension EntryTableViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        setEntryArray()
    }
}

extension EntryTableViewController: RequestNameVCDelegate{
    func saveNewEntry(entryName: String, entry: BracketEntry) {
        DataManager.sharedInstance.updateEntries(entryName: entryName, bracketEntry: entry)
        setEntryArray()
    }
}
