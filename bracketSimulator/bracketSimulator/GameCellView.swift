//
//  GameCellViews.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/8/22.
//

import UIKit

class GameCellView{
    private (set) var cellView: UIView
    private let id: Int
    private(set) var binaryId: String
    
    init(id : Int, binaryId: String){
        self.id = id
        self.binaryId = binaryId
        self.cellView = UIView()
//        self.establishImageFrame()
        self.cellView = initStackObject(teamName: "Unnamed", teamSeed: "Unseeded")
    }
    
//    func updateCellInfo(){
//        cellImage = initStackObject(teamName: "Virginia", teamSeed: "1")
//    }
    
//        
//    func getArrays(){
//        let a = convertCSVIntoArray()
//        print(a)
//    }
        
    func initStackObject(teamName: String, teamSeed: String) -> UIStackView{
        let newStackView = UIStackView()
        let bars = initBarsImage()
        let teamName = initStackLabel(teamName: teamName)
        let teamSeed = initStackSeed(seed: teamSeed)
        
        newStackView.frame.origin = CGPoint(x: 1865, y: 469)
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

    
    func establishImageFrame(){
//        xPos = self.determineX()
//        yPos = self.determineY()
//        self.cellImage.frame = CGRect(x: 40, y: 40, width: 240,
//                                      height: 25 )
//        print(self.cellImage.superview)
//        for subView in self.cellImage.arrangedSubviews{
//            ifSub
//        }
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
