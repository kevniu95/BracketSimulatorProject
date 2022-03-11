//
//  EntryTableViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class EntryTableViewController: UITableViewController {
    var entryDict: [String: BracketEntry] = [:]
    var entryArray = [BracketEntry]()
    var currentEntry: BracketEntry?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initNewButton()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setEntryArray()
        if entryArray.count == 0{
            initSheet()
        }
    }
    
    
    //https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
    func archiveEntries(_ bracketEntries: [BracketEntry]) {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: bracketEntries, requiringSecureCoding: false)
            try data.write(to: url)
        } catch (let error){
            print("Error saing to file: \(error)")
        }
        
    }
    
    func unArchiveEntries() -> [BracketEntry] {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        
        var entries: [BracketEntry]?
        do{
            let data = try Data(contentsOf: url)
            entries = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [BracketEntry]
        } catch (let error){
            print("Error fetching from file: \(error)")
        }
        return entries ?? []
    }
    
    func initNewButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(objcInitSheet))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func objcInitSheet(){
        initSheet()
    }

    func setEntryArray(){
        entryArray = Array(entryDict.values)
        self.tableView.reloadData()
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
        if entryDict.keys.contains(entryName) {
            entryDict[entryName] = entry
        } else{
            entryDict[entryName] = entry
        }
    }
}

extension EntryTableViewController: RequestNameVCDelegate{
    func saveNewEntry(entryName: String, entry: BracketEntry) {
        if entryDict.keys.contains(entryName) {
            entryDict[entryName] = entry
        } else{
            entryDict[entryName] = entry
        }
        setEntryArray()
        self.tableView.reloadData()
    }
    
//    func pushEntry(entry: BracketEntry){
//        currentEntry = entry
//    }
}
