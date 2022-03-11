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
    weak var delegate: EntryTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setupTextfield()
        createButton.addTarget(self, action: #selector(createBracket), for: UIControl.Event.touchUpInside)
    }
    
    // Blank out create button if no text?
    
    @objc func createBracket(){
        guard let bracketName = inputText.text else{
            print("Couldn't unwrap bracket name!")
            return
        }
        if bracketName.count == 0{
            return
        }
        let bracketEntry = BracketEntry(name: bracketName)
        delegate?.saveNewEntry(entryName: bracketName, entry: bracketEntry)
        exitRequestViewController()
    }
    
    func exitRequestViewController(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupTextfield(){
        inputText.delegate = self
        inputText.textAlignment = .center
    }
}

extension RequestNameViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
