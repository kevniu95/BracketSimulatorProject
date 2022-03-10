//
//  NewEntryViewController.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/4/22.
//

import UIKit

class NewEntryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    let bracketFrameScaler = 3.0
    var gameCells = [GameCell]()
    var gamePositions = [gamePosition]()
    var teams = [Team]()
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        initiateScrollView()
        gamePositions = convertGamePositions()
        teams = convertTeams()
        initiateGameCells(gamePositions: gamePositions)
        fillFirstRoundTeam()
        
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
            let currGameCell = GameCell(idNum: ind, referenceScrollView: scrollView, gamePos: gamePosition)
            currGameCell.delegate = self
            gameCells.append(currGameCell)
            scrollView.addSubview(currGameCell.cellImage)
        }
    }
    
    func fillFirstRoundTeam(){
        for ind in 64...127{
            let currGameCell = gameCells[ind - 1]
            let currTeam = teams[ind - 64]
            currGameCell.setTeam(team: currTeam)
        }
    }

    
}

extension NewEntryViewController: GameCellDelegate{
    func resetDownStreamCells(team: Team, nextGames: [Int]) {
        for nextGameInd in nextGames{
            let currGameCell = gameCells[nextGameInd - 1]
            if currGameCell.cellOn && currGameCell.team.id != team.id{
                currGameCell.resetCell()
            }
        }
    }
    func setNewTeam(team: Team, nextGame: Int){
        let currGameCell = gameCells[nextGame - 1]
        currGameCell.setTeam(team: team)
    }
    
    func highlightNextGames(_ nextGames: [Int]) {
        for gameCell in gameCells{
            if nextGames.contains(gameCell.id)  {
                print(gameCell.id)
                gameCell.darken()
                // Temporarily highlight game
            }
        }
    }
    func unhighlightNextGames(_ nextGames: [Int]) {
        for gameCell in gameCells{
            if nextGames.contains(gameCell.id)  {
                print(gameCell.id)
                gameCell.undarken()
                // Temporarily highlight game
            }
        }
    }
    
}
