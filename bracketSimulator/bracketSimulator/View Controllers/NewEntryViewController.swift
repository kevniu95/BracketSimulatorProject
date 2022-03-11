//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: EntryTableViewController?
    weak var inputBracketEntry: BracketEntry?
    var bracketEntry = BracketEntry(name: "")
    let bracketFrameScaler = 3.0
    var gameCells = [GameCell]()
    var gamePositions = [gamePosition]()
    var teams = [Team]()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        // Always the same, no matter if new entry or saved
        initiateScrollView()
        gamePositions = convertGamePositions()
        teams = convertTeams()
        initiateGameCells(gamePositions: gamePositions)
        
        // Can vary based on whether or not entry is a loaded or new one
        fillFirstRoundTeam()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func saveCurrentModel(){
        delegate?.saveEntry(entryName: bracketEntry.name, entry: bracketEntry)
    }
    
    // MARK: Scroll View Functionality
    func initiateScrollView(){
        scrollView.delegate = self
        guard let bracketImageView = initializeBracketImage() else{
            return
        }
        
        addBracketImage(bracketImageView: bracketImageView)
        scrollView.contentSize = CGSize(width: bracketImageView.frame.size.width, height: bracketImageView.frame.size.height)
        scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width * 0.39 ,
                                           y:scrollView.contentSize.height * 0.5)
        
    }

    func initializeBracketImage()-> UIImageView?{
        let bracketImageView: UIImageView = UIImageView()
        guard let bracketImage = UIImage(named: "bracket2022") else {
            print("Couldn't create UI Image!")
            return nil
        }
        bracketImageView.frame.size.width = bracketImage.size.width/bracketFrameScaler
        bracketImageView.frame.size.height = bracketImage.size.height/bracketFrameScaler
        bracketImageView.image =  UIImage(named: "bracket2022")
        return bracketImageView
    }
    
    func addBracketImage(bracketImageView: UIImageView){
        scrollView.addSubview(bracketImageView)
    }

    // MARK: Interact with data model
    func initiateGameCells(gamePositions: [gamePosition]){
        for ind in 1...127{
            let gamePosition = gamePositions[ind - 1]
            let currGameCell = GameCell(idNum: ind, gamePos: gamePosition)
            currGameCell.delegate = self
            gameCells.append(currGameCell)
            scrollView.addSubview(currGameCell.cellImage)
        }
    }
    
    func fillFirstRoundTeam(){
        if let inputBracketEntry = inputBracketEntry{
            bracketEntry = inputBracketEntry
        }
        
        // Load with previous data from bracket entry if it is available
        for ind in 1...63{
            let currGameCell = gameCells[ind - 1]
            let currTeam = bracketEntry.chosenTeams[ind - 1]
            currGameCell.setTeam(team: currTeam)
        }
        // Always instantiate first 64 teams (i.e. last 64 bracket entires)
        // in the same way
        for ind in 64...127{
            let currGameCell = gameCells[ind - 1]
            let currTeam = teams[ind - 64]
            currGameCell.setTeam(team: currTeam)
        }
    }
    
    func setDownstreamCells(team: Team, nextGames: [Int], leaveGames: Int) {
        var gamesLeft = nextGames.count
        for nextGameInd in nextGames{
            if gamesLeft > leaveGames{
                let currGameCell = gameCells[nextGameInd - 1]
                currGameCell.setTeam(team: team)
                bracketEntry.updateTeams(gameID: nextGameInd - 1, newTeam: team)
            }
            gamesLeft -= 1
        }
        saveCurrentModel()
    }
}

extension NewEntryViewController: GameCellDelegate{
    func presentAlert(currCellTeam: Team, currCellID: Int, nextGames: [Int]){
        let id = currCellID
        let alert = UIAlertController(title: "Advance to...", message: nil, preferredStyle: .actionSheet)
        if id >= 64{
            alert.addAction(UIAlertAction(title: "Second Round", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 5)
            }))
        }
        if id >= 32{
            alert.addAction(UIAlertAction(title: "Sweet Sixteen", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 4)
            }))
        }
        if id >= 16{
            alert.addAction(UIAlertAction(title: "Elite Eight", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 3)
            }))
        }
        if id >= 8{
            alert.addAction(UIAlertAction(title: "Final Four", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 2)
            }))
        }
        if id >= 4{
            alert.addAction(UIAlertAction(title: "Championship", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 1)
            }))
        }
        if id >= 2{
            alert.addAction(UIAlertAction(title: "Champion", style: .default, handler: {action in
                self.setDownstreamCells(team: currCellTeam, nextGames: nextGames, leaveGames: 0)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func resetDownstreamCells(team: Team, nextGames: [Int]) {
        for nextGameInd in nextGames{
            let currGameCell = gameCells[nextGameInd - 1]
            if currGameCell.cellOn && currGameCell.team.id != team.id{
                currGameCell.resetCell()
                bracketEntry.updateTeams(gameID: nextGameInd - 1, newTeam: blankTeam())
            }
        }
        saveCurrentModel()
    }
    func setNewTeam(team: Team, nextGame: Int){
        let currGameCell = gameCells[nextGame - 1]
        currGameCell.setTeam(team: team)
        bracketEntry.updateTeams(gameID: nextGame - 1, newTeam: team)
        saveCurrentModel()
    }
}
