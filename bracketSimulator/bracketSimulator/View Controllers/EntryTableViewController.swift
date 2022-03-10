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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setEntryArray()
        
//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(test))
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func test(){
        
    }
    func setEntryArray(){
        entryArray = Array(entryDict.values)
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
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueClosedToDetail"{
//            let svc = segue.destination as! IssueDetailViewController;
//            let issue = issuesArray[tableView.indexPathForSelectedRow!.row]
//            svc.labelTitle = issue.title
//            svc.labelUsername = "@" + issue.user.login
//            svc.labelDateInitial = issue.createdAt
//            svc.textText = issue.body
//            svc.statusImg = "Closed"
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension EntryTableViewController: NewEntryVCDelegate{
    func saveEntry(entryName: String, entry: BracketEntry, new: Bool) {
        print("HERE")
        if entryDict.keys.contains(entryName) {
            print("A")
            entryDict[entryName] = entry
        } else{
            print("B")
            entryDict[entryName] = entry
        }
    }
}
