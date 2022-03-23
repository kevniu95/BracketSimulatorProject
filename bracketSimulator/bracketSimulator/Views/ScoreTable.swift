//
//  ScoreTable.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/22/22.
//

import Foundation
import UIKit

class ScoreTable{
    private(set) var titleLabel: UILabel
    private(set) var scoreLabel: UILabel
    private(set) var hStackObject: UIStackView
    private(set) var vStackObject: UIStackView
    
    init(){
        self.titleLabel = UILabel()
        self.scoreLabel = UILabel()
        self.hStackObject = UIStackView()
        self.vStackObject = UIStackView()
    }
    
    func initTable(scoreDict: [(whichRound: Round, val: Int)]){
        initLabels(scoreDict: scoreDict)
        initVStackObject()
    }
    
    func initVStackObject(){
        let newStackView = UIStackView()
        newStackView.axis = .vertical
        let bigLabel = initBigLabel()
        initHStackObject()
        
        newStackView.frame.origin = CGPoint(x: CGFloat(1292), y: CGFloat(1125))
        
        newStackView.frame.size.width = CGFloat(300)
        newStackView.frame.size.height = CGFloat(140)
        
        newStackView.backgroundColor = .blue.withAlphaComponent(0.25)
        newStackView.layer.borderColor = UIColor.black.cgColor
        newStackView.layer.borderWidth = 2
        newStackView.layer.cornerRadius = 5
        newStackView.layer.masksToBounds = true
        
        newStackView.addArrangedSubview(bigLabel)
        newStackView.addArrangedSubview(self.hStackObject)
        self.vStackObject = newStackView
    }
    
    func initBigLabel() -> UILabel{
        let bigLabel = UILabel()

        bigLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        
        bigLabel.text = "Simulation Scores by Round: "
        
        bigLabel.frame.size.height = CGFloat(20)
        bigLabel.frame.size.width = CGFloat(175)
            
            
        bigLabel.textAlignment = .center
        return bigLabel
    }

    
    func initHStackObject(){
        let newStackView = UIStackView()
        
        newStackView.frame.size.width = CGFloat(225)
        newStackView.frame.size.height = CGFloat(175)
        newStackView.spacing = 0
        newStackView.addArrangedSubview(self.titleLabel)
        newStackView.addArrangedSubview(self.scoreLabel)
        newStackView.distribution = .fillEqually
        self.hStackObject = newStackView
    }
    
  
    func initLabels(scoreDict: [(whichRound: Round, val: Int)]){
        let scoreTableLabels = UILabel()
        let scoreTableScores = UILabel()

        scoreTableLabels.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        scoreTableScores.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        
        scoreTableLabels.text = ""
        scoreTableScores.text = ""
        
        var ctr = 0
        for entry in scoreDict{
            var  prepend = "\n"
            if ctr == 0{
                prepend = ""
            }
            scoreTableLabels.text! +=  prepend + entry.whichRound.getString()
            scoreTableScores.text! +=  prepend + String(entry.val) + "/320"
            ctr += 1
        }
        
        scoreTableLabels.numberOfLines = 6
        scoreTableScores.numberOfLines = 6
        scoreTableLabels.frame.size.height = CGFloat(200)
        scoreTableScores.frame.size.height = CGFloat(200)
        
        scoreTableLabels.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        scoreTableScores.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        
        scoreTableScores.textAlignment = .right
        self.titleLabel = scoreTableLabels
        self.scoreLabel = scoreTableScores
    }
}
