//
//  teamEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/7/22.
//

import Foundation
import UIKit

class GameCell{
    weak var delegate: GameCellDelegate?
    // Given by initializer
    private (set) var id: Int
    private(set) var gamePos: gamePosition
    // Calculated on initialization
    private (set) var nextGames: [Int]
    private(set) var binaryId: String
    private(set) var cellImage: UIStackView
    private(set) var cellOn: Bool
    // Filled out later
    private(set) var team: Team
    
    init(idNum: Int, gamePos: gamePosition){
        id = idNum
        cellImage = UIStackView()
        team = Team(teamid: -1, binID: "", firstCellID: -1, name: "", seed: 0, image: UIImage())
        binaryId = ""
        cellOn = false
        nextGames = [Int]()
        
        self.gamePos = gamePos
        self.nextGames = getNextGames()
        self.setBinaryId()
        self.initCellImage()
        self.initiateRecognizers()
    }
    
    // MARK: Initializer functions
    func getNextGames() -> [Int]{
        var gameIds = [Int]()
        var tmpId = self.id
        while tmpId > 1{
            tmpId = Int(Float(tmpId) / 2.0)
            gameIds.append(tmpId)
        }
        return gameIds
    }
    
    func setBinaryId(){
        self.binaryId = convertToBin(num: id, toSize: 7)
    }
    
    func initCellImage(){
        cellImage = initStackObject()
    }
    
    func initiateRecognizers(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(handleLongPress(_:)))
        cellImage.addGestureRecognizer(tapRecognizer)
        cellImage.addGestureRecognizer(longPressRecognizer)
    }
    
    // MARK: Stack View Gesture Recognizers
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer){
        print("I was tapped!!!")
        if id > 1{
            let nextGame = nextGames[0]
            delegate?.setNewTeam(team: self.team, nextGame: nextGame)
        }
    }
        
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        delegate?.presentAlert(currCellTeam: self.team, currCellID: self.id, nextGames: self.nextGames)
    }
    
    // MARK: State Challenge Caller
    func setTeam(team: Team){
        let prevTeam = self.team
        // Check to see if setTeam is a "real update"
        // or filling out cells if it's a whole new bracket
        // entry
        if team.teamid > -1 {
            self.team = team
            self.cellOn = true
//            print("Updating cell image for \(self.team.name) at cell number \(self.id)")
            updateCellImage()
        }
        
        // Check to see if team name is changed from before
            // Ex. If I pick Norfolk State to make the championship then switch to
            //      Gonzaga to beat them in the first round, need to update bracket
        if self.team.teamid != prevTeam.teamid && prevTeam.teamid >= 0{
            delegate?.resetDownstreamCells(team: team, nextGames: nextGames, prevTeam: prevTeam)
        }
    }
            
    func resetCell(){
        self.cellImage.isHidden = true
        self.cellImage.isUserInteractionEnabled = false
        self.team = blankTeam()
    }
    
    func updateCellImage(){
        self.cellImage.isHidden = false
        self.cellImage.isUserInteractionEnabled = true
        guard let cellTeam = self.cellImage.arrangedSubviews[1] as? UILabel else {
            print("Couldn't unwrap text label in cell!")
            return
        }
        guard let cellSeed = self.cellImage.arrangedSubviews[2] as? UILabel else{
            print("Couldn't unwrap seed label in cell!")
            return
        }
        cellTeam.text = self.team.name
        cellSeed.text = String(self.team.seed)
    }
    
    
    // MARK: Initial Cell Image
    func initStackObject() -> UIStackView{
        let newStackView = UIStackView()
        let bars = initBarsImage()
        let teamName = initStackLabel()
        let teamSeed = initStackSeed()
        newStackView.isHidden = true
        newStackView.isUserInteractionEnabled = false
        
        newStackView.frame.origin = CGPoint(x: CGFloat(self.gamePos.x), y: CGFloat(self.gamePos.y))
        newStackView.frame.size.width = CGFloat(210)
        newStackView.frame.size.height = CGFloat(30)
        newStackView.backgroundColor = UIColor.opaqueSeparator
        newStackView.layer.borderColor = UIColor.black.cgColor
        newStackView.layer.borderWidth = 0.5
        newStackView.layer.cornerRadius = 5
        newStackView.layer.masksToBounds = true
        newStackView.spacing = 10
        newStackView.addArrangedSubview(bars)
        newStackView.addArrangedSubview(teamName)
        newStackView.addArrangedSubview(teamSeed)
        return newStackView
    }
    
    func initBarsImage()-> UIImageView{
        let bracketImageView = UIImageView()
        bracketImageView.frame.size.height = 5
        bracketImageView.image = UIImage(systemName: "line.3.horizontal")
        bracketImageView.tintColor = UIColor.secondaryLabel
        bracketImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return bracketImageView
    }
    
    func initStackLabel()-> UILabel{
        let bracketImageView = UILabel()
        bracketImageView.text = self.team.name
        bracketImageView.font = UIFont(name:"HelveticaNeue-Bold", size: 16)

        bracketImageView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        bracketImageView.minimumScaleFactor = 0.8
        bracketImageView.adjustsFontSizeToFitWidth = true
        return bracketImageView
    }
    
    func initStackSeed()->UILabel{
        let bracketImageView = UILabel()
        bracketImageView.text = String(self.team.seed)
        bracketImageView.textAlignment = .center
        bracketImageView.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        return bracketImageView
    }
}

