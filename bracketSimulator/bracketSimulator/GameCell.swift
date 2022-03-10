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
    private (set) var id: Int
    private (set) var nextGames: [Int]
    private let refScroll: UIScrollView
    private(set) var cellImage: UIStackView
    private(set) var team: Team
    private(set) var gamePos: gamePosition
    private(set) var binaryId: String
    private(set) var cellOn: Bool

    
    init(idNum: Int, referenceScrollView: UIScrollView, gamePos: gamePosition){
        id = idNum
        cellImage = UIStackView()
        refScroll = referenceScrollView
        team = Team(id: 0, binID: "", firstCellID: 0, name: "", seed: 0)
        binaryId = ""
        cellOn = false
        nextGames = [Int]()
        
        self.gamePos = gamePos
        self.nextGames = getNextGames()
        self.setBinaryId()
        self.initCellImage()
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
    
    
    // MARK: State Challenge Caller
    func setTeam(team: Team){
        let prevTeam = self.team
        self.team = team
        self.cellOn = true
        updateCellImage()
    
        if prevTeam.id == 0{
            initiateRecognizers()
        } else{
            if self.team.id != prevTeam.id{
                delegate?.resetDownStreamCells(team: team, nextGames: nextGames)
            }
        }
        
    }
        
    
    // MARK: Stack View Gestures
    func initiateRecognizers(){

//        let labelGestureRecognizer = UIPanGestureRecognizer(target: self,
//                                                action: #selector(handlePan(_:)))
//        labelGestureRecognizer.delegate = vc
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(handleLongPress(_:)))
        
        cellImage.addGestureRecognizer(tapRecognizer)
        cellImage.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer){
        guard let labelView = gestureRecognizer.view else{
            print("gestureRecognizer doesn't have a view!")
            return
        }
        let nextGame = nextGames[0]
        delegate?.setNewTeam(team: self.team, nextGame: nextGame)
        
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        guard let labelView = gestureRecognizer.view else{
            print ("gestureRecognizer doesn't have a view!")
            return
        }
        let nextGames = getNextGames()
        delegate?.highlightNextGames(nextGames)
        if gestureRecognizer.state == .ended{
            delegate?.unhighlightNextGames(nextGames)
        }
    }
    
//    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
//        guard let labelView = gestureRecognizer.view else{
//            print ("gestureRecognizer doesn't have a view!")
//            return
//        }
//
//        let translation = gestureRecognizer.translation(in: vc.view)
//        labelView.center = CGPoint(x: labelView.center.x + translation.x,
//                                  y: labelView.center.y + translation.y)
//        gestureRecognizer.setTranslation(CGPoint.zero, in: vc.view)
//
//        let nextGames = getNextGames()
//        delegate?.highlightNextGames(nextGames)
////        print(gestureStartPoint)
//        if gestureRecognizer.state == .ended{
//            delegate?.unhighlightNextGames(nextGames)
//        }
//    }
    
    func resetCell(){
        self.cellImage.isHidden = true
        self.cellImage.isUserInteractionEnabled = false
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
    

    func darken(){
        cellImage.isHidden = false
//        cellImage.addArrangedSubview(imageCover())
//        cellImage.bringSubviewToFront(cellImage.subviews[4])
//        cellImage.bringSubviewToFront(cellImage[4])

        cellImage.backgroundColor = UIColor.black
    }
    
    func undarken(){
        cellImage.isHidden = true
//        cellImage.addArrangedSubview(imageCover())
//        cellImage.bringSubviewToFront(cellImage.subviews[4])
//        cellImage.bringSubviewToFront(cellImage[4])

        cellImage.backgroundColor = UIColor.opaqueSeparator
    }
    
    // MARK: Initial CEll Image
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
    
//    func imageCover() -> UIView{
//        print("a")
//        let newStackView = UIView()
//        newStackView.frame.origin = CGPoint(x: self.xPos, y: self.yPos)
//        newStackView.frame.size.width = CGFloat(210)
//        newStackView.frame.size.height = CGFloat(30)
//        newStackView.backgroundColor = UIColor.black
//        newStackView.layer.borderColor = UIColor.black.cgColor
//        newStackView.layer.borderWidth = 0.5
//        newStackView.layer.cornerRadius = 5
//        newStackView.layer.masksToBounds = true
//
//        return newStackView
//    }
    
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

