//
//  RequestNameViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import UIKit

class RequestNameViewController: UIViewController{
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var commandLabel: UILabel!
    var copy = false
    var copyOf: BracketEntry?
    weak var delegate: EntryTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCommandText()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setupTextfield()
        createButton.addTarget(self, action: #selector(createBracket), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: Initial set up of VC
    func determineCommandText(){
        if copy{
            commandLabel.text = "Copying '\(copyOf!.name)'\nGive your new entry a name"
        } else{
            commandLabel.text = "Give your new entry a name."
        }
    }
    func setupTextfield(){
        inputText.delegate = self
        inputText.textAlignment = .center
    }
    
    // MARK: Create bracket on "create" tap
    @objc func createBracket(){
        guard let bracketName = inputText.text else{
            print("Couldn't unwrap bracket name!")
            return
        }
        if bracketName.count == 0{
            return // If no name given ,do nothing
        }
        if Array(DataManager.sharedInstance.bracketEntries.keys).contains(bracketName){
            commandLabel.text = "You already have an entry named '\(bracketName)'!\nTry another!"
            return
        }
        let bracketEntry = fillBracketEntry(bracketName: bracketName)
        delegate?.saveNewEntry(entryName: bracketName, entry: bracketEntry)
        exitRequestViewController()
    }
    
    // Determine if bracket is copy or entirely new
    func fillBracketEntry(bracketName: String) -> BracketEntry{
        var teams: [Int]
        var winner: String
        var completed: Bool
        if let copyOf = copyOf{
            teams = copyOf.chosenTeams
            winner = copyOf.winner
            completed = copyOf.completed
            return BracketEntry(name: bracketName, chosenTeams: teams, winner: winner, completed: completed, recentSims: [])
        } else {return BracketEntry(name: bracketName)}
        
    }
    
    // MARK: Exit VC
    func exitRequestViewController(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension RequestNameViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
