//
//  BracketEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

class BracketEntry: NSObject, NSCoding{
    private (set) var name: String
    private (set) var chosenTeams: [Team]
    private (set) var winner: String
    private (set) var scores: [Int]
    private (set) var recentScore: Int
    
    init(name: String, chosenTeams: [Team], winner: String, scores: [Int], recentScore: Int){
        self.name = name
        self.chosenTeams = chosenTeams
        self.winner = winner
        self.scores = scores
        self.recentScore = recentScore
    }
    
    convenience init(name: String){
        let thisName = name
        let chosenTeams = initiateTeams(numTeams: 64)
        let winner = ""
        let scores = [Int]()
        let recentScore = 0
        
        self.init(name: thisName, chosenTeams: chosenTeams, winner: winner, scores: scores, recentScore: recentScore)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let chosenTeams = aDecoder.decodeObject(forKey: "chosenTeams") as? [Team],
              let winner = aDecoder.decodeObject(forKey: "winner") as? String,
              let scores = aDecoder.decodeObject(forKey: "scores") as? [Int],
              let recentScore = aDecoder.decodeObject(forKey: "recentScore") as? Int else{
                  return nil
              }
        self.init(name: name, chosenTeams: chosenTeams, winner: winner, scores: scores, recentScore: recentScore)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.chosenTeams, forKey: "chosenTeams")
        coder.encode(self.winner, forKey: "winner")
        coder.encode(self.scores, forKey: "score")
        coder.encode(self.recentScore, forKey: "recentScore")
    }
    
    
    
    func setName(name: String){
        self.name = name        
    }
        
    func updateTeams(gameID: Int, newTeam: Team){
        self.chosenTeams[gameID] = newTeam
        if gameID == 1{
            self.winner = newTeam.name
        }
    }
}
