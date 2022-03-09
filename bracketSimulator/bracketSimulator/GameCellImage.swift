//
//  GameCellImage.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import UIKit

class GameCellImage: UIView {
    private (set) var id: Int
    private let refScroll: UIScrollView
    private(set) var cellImage: UIStackView
    private(set) var xPos: CGFloat
    private(set) var yPos: CGFloat
    private(set) var team: Team
    private(set) var gamePos: gamePosition
    private(set) var binaryId: String
    private(set) var cellOn: Bool

    
    required init(idNum: Int, referenceScrollView: UIScrollView, gamePos: gamePosition){
        id = idNum
        cellImage = UIStackView()
        refScroll = referenceScrollView
        xPos = 0
        yPos = 0
        team = Team(id: 0, binID: "", firstCellID: 0, name: "", seed: 0)
        binaryId = ""
        cellOn = false
        
        self.gamePos = gamePos
        super.init(frame: .zero)
        
        self.initiatePosition()
        self.setBinaryId()
        self.fillCellImage()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNextGames() -> [Int]{
        var gameIds = [Int]()
        var tmpId = self.id
        while tmpId > 1{
            tmpId = Int(Float(tmpId) / 2.0)
            gameIds.append(tmpId)
        }
        return gameIds
        
    }
    
    func setTeam(team: Team){
        self.team = team
        cellOn = true
        updateCellImage()
        initiatePosition()
    }
    
    func initiatePosition(){
        if self.id == gamePos.id{
            self.xPos = CGFloat(gamePos.x)
            self.yPos = CGFloat(gamePos.y)
        }
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
    
    func setBinaryId(){
        self.binaryId = convertToBin(num: id, toSize: 7)
    }
    
    func fillCellImage(){
        cellImage = initStackObject()
    }
    
    func initStackObject() -> UIStackView{
        let newStackView = UIStackView()
        let bars = initBarsImage()
        let teamName = initStackLabel()
        let teamSeed = initStackSeed()
        newStackView.isHidden = true
        newStackView.isUserInteractionEnabled = false
        
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

