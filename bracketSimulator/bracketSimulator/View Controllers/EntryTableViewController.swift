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
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setEntryArray()
        if entryArray.count == 0{
            initSheet()
        }
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        print("Trying to save this damn thing")
        print(entryName)
        if entryDict.keys.contains(entryName) {
            entryDict[entryName] = entry
        } else{
            entryDict[entryName] = entry
        }
        print("I have saved the entry, here is what it looks like right now")
        for team in entryDict[entryName]!.chosenTeams{
            if team.id > -1{
                print(team.name)
            }
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


//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(test))
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

//
//func moveToEntryVC() {
////        let newEntryVC = self.storyboard?.instantiateViewController(withIdentifier: "NewEntryViewController") as! NewEntryViewController
////        newEntryVC.delegate = self
////        if let currentEntry = currentEntry{
////            print(currentEntry.name)
////            newEntryVC.inputBracketEntry = currentEntry
////        }
////        self.navigationController?.pushViewController(newEntryVC, animated: true)
//}
