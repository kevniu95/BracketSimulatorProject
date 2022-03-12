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
    var completed: Bool
//    private (set) var scores: [Int]
//    private (set) var recentScore: Int
    
    init(name: String, chosenTeams: [Int], winner: String, completed: Bool){
        self.name = name
        self.chosenTeams = chosenTeams
        self.winner = winner
        self.completed = completed
//        self.scores = scores
//        self.recentScore = recentScore
    }
    
    convenience init(name: String){
        let thisName = name
        let chosenTeams = initiateTeams(numTeams: 64)
        let winner = "<No winner selected>"
        let completed = false
//        let scores = [Int]()
//        let recentScore = 0
        
        self.init(name: thisName, chosenTeams: chosenTeams, winner: winner, completed: completed)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let chosenTeams = aDecoder.decodeObject(forKey: "chosenTeams") as? [Int],
              let winner = aDecoder.decodeObject(forKey: "winner") as? String
            else{
                  return nil
              }
        let completed = aDecoder.decodeBool(forKey: "completed") as Bool
//              let recentScore = aDecoder.decodeObject(forKey: "recentScore") as? Int
//        guard let scores = aDecoder.decodeObject(forKey: "scores") as? [Int] else{
//            print("BBB")
//            return nil
//        }
                self.init(name: name, chosenTeams: chosenTeams, winner: winner, completed: completed)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.chosenTeams, forKey: "chosenTeams")
        coder.encode(self.winner, forKey: "winner")
        coder.encode(self.completed, forKey: "completed")
//        coder.encode(self.scores, forKey: "score")
//        coder.encode(self.recentScore, forKey: "recentScore")
    }
        
    func setName(name: String){
        self.name = name        
    }
    
    func getScore(){
        print(self.chosenTeams)
    }
    
    func checkComplete() -> Bool{
        var filledTeams = 0
        for teamid in chosenTeams{
            if teamid >= 0 && teamid <= 63{
                filledTeams += 1
            }
        }
        if filledTeams == 63{
            return true
        } else {return false}
    }
    
    func getWinner() -> String{
        let winnerID = self.chosenTeams[0]
        if winnerID > 0{
            return DataManager.sharedInstance.teams[winnerID].name
        }
        else{ return "<No winner selected>"}
    }
        
    func updateTeams(gameID: Int, newTeam: Team){
        self.chosenTeams[gameID] = newTeam.teamid
        self.winner = getWinner()
        self.completed = checkComplete()
        if self.completed{
            print("I am completed!")
        }
    }
}
