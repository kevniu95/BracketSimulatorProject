//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scoreLabelTitle: UILabel!
    
    @IBOutlet weak var scoreLabelScores: UILabel!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    var bracketImgView = UIImageView()
    weak var delegate: NewEntryVCDelegate?
    weak var inputBracketEntry: BracketEntry?
    var bracketEntry = BracketEntry(name: "")
    let bracketFrameScaler = 3.0
    var gameCells = [GameCell]()
    var gamePositions = DataManager.sharedInstance.gamePositions
    var teams = DataManager.sharedInstance.teams
    var lastZoomScale: CGFloat = 0
    var isScored: Bool = false
    var simulationResults: [Int]?
    var bracketTeams = [Int]()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        // Always the same, no matter if new entry or saved
        setBracketEntry()
        initiateScrollView()
        initBracketTeams()
        initiateGameCells(gamePositions: gamePositions)
        fillFirstRoundTeam()
        setNavBar()
        initLockButton()
        print("\(bracketEntry.name) completed: \(bracketEntry.completed)")
        print("\(bracketEntry.name) locked: \(bracketEntry.locked)")
    }
    
    // MARK: I. Nav Bar
    func setBracketEntry(){
        if let inputBracketEntry = inputBracketEntry{
            bracketEntry = inputBracketEntry
        }
        print("\nLooking at an actual bracket. Here is some information on whether it has been completed/locked:")
    }
    
    func setNavBar(){
        if bracketEntry.completed{
            navBarTitle.title = bracketEntry.name
        }
        else{
            navBarTitle.title = "Fill me out!"
        }
        
    }
    
    // MARK: A. Lock Button
    func initLockButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "lock.open"), style: .done, target: self, action: #selector(setLockButton))
        if bracketEntry.completed{
            rightBarButtonItem.image = UIImage(systemName: "lock")
            if bracketEntry.locked{
                rightBarButtonItem.isEnabled = false
            } else {rightBarButtonItem.isEnabled = true}
        }
        else{
            rightBarButtonItem.image = UIImage(systemName: "lock.open")
            rightBarButtonItem.isEnabled = false
        }
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func setLockButton(){
        if !bracketEntry.completed || bracketEntry.locked{
            print("This should not be happening, double check")
            return
        }
        let alert = UIAlertController(title: "Permanently lock this entry from editing?", message: "Only locked entries can be scored, but you can always make a new copy.", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.bracketEntry.lockBracket()
            self.saveCurrentModel()
            self.initLockButton()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    // MARK: B. Scroll View
    // Set scroll view parameters
    func initiateScrollView(){
        scrollView.delegate = self
        
        guard let bracketImageView = initializeBracketImage() else{
            return
        }
        
        self.bracketImgView = bracketImageView
        
        addBracketImage(bracketImageView: bracketImageView)
        scrollView.contentSize = CGSize(width: bracketImageView.frame.size.width, height: bracketImageView.frame.size.height)
        scrollView.contentOffset = CGPoint(x:scrollView.contentSize.width * 0.39 ,
                                           y:scrollView.contentSize.height * 0.5)
        scrollView.setZoomScale(0.4, animated: false)
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 1.5
    }
    
    // Allow zooming in
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.bracketImgView
    }
    
    // Get bracket image into scrollview
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

    // MARK: C. Interact with (mostly) GameCell Objects
    // Add game cells to bracket image
    func initiateGameCells(gamePositions: [gamePosition]){
        for ind in 1...127{
            let gamePosition = gamePositions[ind - 1]
            let currGameCell = GameCell(idNum: ind, gamePos: gamePosition)
            currGameCell.delegate = self
            gameCells.append(currGameCell)
            scrollView.subviews[0].addSubview(currGameCell.cellImage)
            scrollView.subviews[0].addSubview(currGameCell.correctionLabel)
        }
        scrollView.subviews[0].isUserInteractionEnabled = true
    }
    
    func initBracketTeams(){
        if let simResults = simulationResults{
            print("I am using simulation results to fill out this bracket!")
            self.bracketTeams = simResults
            self.isScored = true
        }
        else {
            print("I am using the bracket entry to fill out this bracket!")
            self.bracketTeams = bracketEntry.chosenTeams
            self.isScored = false
        }
        
    }
    
    
    func initScoreLabels(){
        let scoreTableLabels = UILabel()
        let scoreTableScores = UILabel()
        
        scoreTableLabels.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        scoreTableScores.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        
        scoreTableLabels.text = "Round of 64\nRound of 32\nSweet Sixteen\nElite Eight\nFinal Four\n Championship"
//        scoreTableScores.\
    }
    
    
    // Fill first round of teams (64 - 127) - this will always happen
    // Then fill out "middle" 63 entries based on previously-filled data if available
        // THis stored in bracketEntry.chosenTeams
    func fillFirstRoundTeam(){
        // Load with previous data from bracket entry if it is available
        for ind in 1...63{
            let currGameCell = gameCells[ind - 1]
            
            // Set team in bracket entry
            let currBracketTeamInd = bracketTeams[ind - 1]
            var currBracketTeam: Team
            if currBracketTeamInd < 0 || currBracketTeamInd >= 65{
                currBracketTeam = blankTeam()
            } else {currBracketTeam = teams[currBracketTeamInd]}
            // Set the team "selected" by the model, if this is a view of a simulation
            var currSelectedTeam: Team?
            let currSelectedTeamInd = bracketEntry.chosenTeams[ind - 1]
            if isScored{
                currSelectedTeam = teams[currSelectedTeamInd]
                currGameCell.setTeam(bracketTeam: currBracketTeam, selectedTeam: currSelectedTeam)
                
            }
            else{
                currGameCell.setTeam(bracketTeam: currBracketTeam, selectedTeam: nil)
            }
            
        }
        // Always instantiate first 64 teams (i.e. last 64 bracket entires)
        // in the same way
        for ind in 64...127{
            let currGameCell = gameCells[ind - 1]
            let currTeam = teams[ind - 64]
            currGameCell.setTeam(bracketTeam: currTeam, selectedTeam: nil)
        }
    }
    
    // MARK: Interact with (mostly) data model
    func saveCurrentModel(){
        delegate?.saveEntry(entryName: bracketEntry.name, entry: bracketEntry)
    }
    
    // Allows filling of cells continuously down bracket as far as requested
    func setDownstreamCells(team: Team, nextGames: [Int], leaveGames: Int) {
        if !bracketEntry.locked{
            var gamesLeft = nextGames.count
            for nextGameInd in nextGames{
                if gamesLeft > leaveGames{
                    let currGameCell = gameCells[nextGameInd - 1]
                    currGameCell.setTeam(bracketTeam: team, selectedTeam: nil)
                    bracketEntry.updateTeams(gameID: nextGameInd - 1, newTeam: team)
                }
                gamesLeft -= 1
            }
            saveCurrentModel()
            initLockButton()
        }
    }
}

extension NewEntryViewController: GameCellDelegate{
    // Long-pressing a team name allows you to choose how far you want team to go
    func presentAlert(currCellTeam: Team, currCellID: Int, nextGames: [Int]){
        let id = currCellID
        let teamName = currCellTeam.name
        let alert = UIAlertController(title: "Advance \(teamName) to...", message: nil, preferredStyle: .actionSheet)
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
    
    // Resolve conflicts based on a current bracket selection
    func resetDownstreamCells(team: Team, nextGames: [Int], prevTeam: Team) {
        if !bracketEntry.locked{
            for nextGameInd in nextGames{
                let currGameCell = gameCells[nextGameInd - 1]
                if currGameCell.cellOn && currGameCell.team.teamid == prevTeam.teamid{
                    currGameCell.resetCell()
                    bracketEntry.updateTeams(gameID: nextGameInd - 1, newTeam: blankTeam())
                }
            }
            saveCurrentModel()
            initLockButton()
        }
    }
    func setNewTeam(team: Team, nextGame: Int){
        if !bracketEntry.locked{
            let currGameCell = gameCells[nextGame - 1]
            currGameCell.setTeam(bracketTeam: team, selectedTeam: nil)
            bracketEntry.updateTeams(gameID: nextGame - 1, newTeam: team)
            saveCurrentModel()
            initLockButton()
        }
    }
}
