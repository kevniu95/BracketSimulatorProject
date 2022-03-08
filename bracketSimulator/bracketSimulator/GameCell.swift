//
//  teamEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/7/22.
//

import Foundation
import UIKit

class GameCell{
    private let id: Int
    private let refScroll: UIScrollView
    private(set) var cellImage: UIStackView
    private(set) var xPos: CGFloat
    private(set) var yPos: CGFloat
    private(set) var teamName: String
    private(set) var teamSeed: String
    private(set) var gameLocations: [gameLocation]
    
    init(idNum: Int, referenceScrollView: UIScrollView, gameLocations: [gameLocation]){
        id = idNum
        cellImage = UIStackView()
        refScroll = referenceScrollView
        xPos = 0
        yPos = 0
        teamName = ""
        teamSeed = ""
        self.gameLocations = gameLocations
        self.initiatePosition()
//        self.establishImageFrame()
        self.fillCellImage()
    }
    
    func initiatePosition(){
        for gameLocation in self.gameLocations{
            if self.id == gameLocation.id{
                self.xPos = CGFloat(gameLocation.x)
                self.yPos = CGFloat(gameLocation.y)
            }
        }
    }
    
    func fillCellImage(){
        cellImage = initStackObject(teamName: "Unnamed", teamSeed: "17")
    }
    
//    func switchTeamName(){
//        let teamLabel = self.cellImage.arrangedSubviews[1] as? UILabel
//        guard let teamLabel = teamLabel else {
//            return
//        }
//        teamLabel.text = "University of Virginia"
//    }
    
//    func establishImageFrame(){
//        xPos = self.determineX()
//        yPos = self.determineY()
////        self.cellImage.frame = CGRect(x: 40, y: 40, width: 240,
////                                      height: 25 )
////        print(self.cellImage.superview)
////        for subView in self.cellImage.arrangedSubviews{
////            ifSub
////        }
//    }
    
//    func pullGames(){
//        let a = csv(data: "gameCellPositions.csv")
//        print(a)
//    }

    func initStackObject(teamName: String, teamSeed: String) -> UIStackView{
        let newStackView = UIStackView()
        let bars = initBarsImage()
        let teamName = initStackLabel(teamName: teamName)
        let teamSeed = initStackSeed(seed: teamSeed)
        
        newStackView.frame.origin = CGPoint(x: self.xPos, y: self.yPos)
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
    
    func initStackLabel(teamName: String)-> UILabel{
        let bracketImageView = UILabel()
        bracketImageView.text = "Jacksonville State"
        bracketImageView.font = UIFont(name:"HelveticaNeue-Bold", size: 16)

        bracketImageView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        bracketImageView.minimumScaleFactor = 0.8
        bracketImageView.adjustsFontSizeToFitWidth = true
        return bracketImageView
    }
    
    func initStackSeed(seed: String)->UILabel{
        let bracketImageView = UILabel()
        bracketImageView.text = "16"
        bracketImageView.textAlignment = .center
        bracketImageView.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        return bracketImageView
    }
}

//
//private(set) var binaryId: String
//
//func determineX() -> CGFloat{
//    let returnX = self.refScroll.center.x * CGFloat(self.id)
//    return returnX
//}
//
//func determineY() -> CGFloat{
//    let returnY = self.refScroll.center.x * CGFloat(self.id)
//    return returnY
//}

//
//
//func setBinaryId(){
//    let tmpStr = String(id, radix: 2)
//    self.binaryId = pad(string: tmpStr, toSize: 6)
//}
//
//
//
//func pad(string : String, toSize: Int) -> String {
//  var padded = string
//  for _ in 0..<(toSize - string.count) {
//    padded = "0" + padded
//  }
//    return padded
//}

//binaryId = ""
//self.setBinaryId()
