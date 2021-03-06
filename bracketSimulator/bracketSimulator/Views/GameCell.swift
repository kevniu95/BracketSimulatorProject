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
    private(set) var selectedTeam: Team?
    private(set) var correctionLabel: UILabel
//    private(set) var isScored: Bool
    
    init(idNum: Int, gamePos: gamePosition){
        id = idNum
        cellImage = UIStackView()
        team = Team(teamid: -1, binID: "", firstCellID: -1, name: "", seed: 0, image: UIImage())
        binaryId = ""
        cellOn = false
        nextGames = [Int]()
        correctionLabel = UILabel()
//        self.isScored = isScored
        
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
        self.correctionLabel = initCorrection()
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
        print("Bracket cell was tapped!")
        if id > 1{
            let nextGame = nextGames[0]
            delegate?.setNewTeam(team: self.team, nextGame: nextGame)
        }
    }
        
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        delegate?.presentAlert(currCellTeam: self.team, currCellID: self.id, nextGames: self.nextGames)
    }
    
    // MARK: State Change Caller
    func setTeam(bracketTeam: Team, selectedTeam: Team?){
        let prevTeam = self.team
        // Check to see if setTeam is a "real update"
        // or filling out cells if it's a whole new bracket
        // entry
        if bracketTeam.teamid > -1 {
            self.team = bracketTeam
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
        
        if let selectedTeam = selectedTeam{
            self.selectedTeam = selectedTeam
            updateCellImage()
        }
    }
    
    // Unhide and allow user interaction - update a hidden cell for previously
    // unselected game
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
        
        if let selectedTeam = self.selectedTeam{
            if selectedTeam.teamid != self.team.teamid{
                self.cellImage.backgroundColor = .red.withAlphaComponent(0.25)
                self.correctionLabel.text = "You chose: \(selectedTeam.name)"
                self.correctionLabel.isHidden = false
            } else {
                self.cellImage.backgroundColor = .green.withAlphaComponent(0.25)
            }
        }
    }
    
    // GO back to hiding and disablign user interaction on a cell
    func resetCell(){
        self.cellImage.isHidden = true
        self.cellImage.isUserInteractionEnabled = false
        self.team = blankTeam()
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
    
    
    
    func initCorrection() -> UILabel{
        let correction = UILabel()
        correction.isHidden = true
        var newYPos: CGFloat
        if self.id == 1{
            newYPos = CGFloat(self.gamePos.y) - 40
        } else {newYPos = CGFloat(self.gamePos.y) - 29}
        
        correction.frame.origin = CGPoint(x: CGFloat(self.gamePos.x), y: newYPos)
        correction.frame.size.width = CGFloat(210)
        correction.frame.size.height = CGFloat(30)
        correction.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        
        correction.minimumScaleFactor = 0.8
        correction.adjustsFontSizeToFitWidth = true
        return correction
    }
    
    func initStackSeed()->UILabel{
        let bracketImageView = UILabel()
        bracketImageView.text = String(self.team.seed)
        bracketImageView.textAlignment = .center
        bracketImageView.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        return bracketImageView
    }
}

