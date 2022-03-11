//
//  BracketEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

class BracketEntry: NSObject, NSCoding{
    private (set) var name: String
    private (set) var chosenTeams: [Int] // Stores team IDs
    private (set) var winner: String
//    private (set) var scores: [Int]
//    private (set) var recentScore: Int
    
    init(name: String, chosenTeams: [Int], winner: String){
        self.name = name
        self.chosenTeams = chosenTeams
        self.winner = winner
//        self.scores = scores
//        self.recentScore = recentScore
    }
    
    convenience init(name: String){
        let thisName = name
        let chosenTeams = initiateTeams(numTeams: 64)
        let winner = ""
//        let scores = [Int]()
//        let recentScore = 0
        
        self.init(name: thisName, chosenTeams: chosenTeams, winner: winner)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let chosenTeams = aDecoder.decodeObject(forKey: "chosenTeams") as? [Int],
              let winner = aDecoder.decodeObject(forKey: "winner") as? String
//              let recentScore = aDecoder.decodeObject(forKey: "recentScore") as? Int
        else{
                  print("AAAA")
                  return nil
              }
//        guard let scores = aDecoder.decodeObject(forKey: "scores") as? [Int] else{
//            print("BBB")
//            return nil
//        }
        self.init(name: name, chosenTeams: chosenTeams, winner: winner)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.chosenTeams, forKey: "chosenTeams")
        coder.encode(self.winner, forKey: "winner")
//        coder.encode(self.scores, forKey: "score")
//        coder.encode(self.recentScore, forKey: "recentScore")
    }
        
    func setName(name: String){
        self.name = name        
    }
        
    func updateTeams(gameID: Int, newTeam: Team){
        self.chosenTeams[gameID] = newTeam.teamid
        if gameID == 0{
            self.winner = newTeam.name
        }
    }
}



