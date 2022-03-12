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
    private (set) var locked: Bool
    private (set) var simulations: Int
    private (set) var aggScore: Int
//    private (set) var scores: [Int]
//    private (set) var recentScore: Int
    
    init(name: String, chosenTeams: [Int], winner: String, completed: Bool, locked: Bool, simulations: Int, aggScore: Int){
        self.name = name
        self.chosenTeams = chosenTeams
        self.winner = winner
        self.completed = completed
        self.locked = locked
        self.simulations = simulations
        self.aggScore = aggScore
    }
    
    convenience init(name: String){
        let thisName = name
        let chosenTeams = initiateTeams(numTeams: 64)
        let winner = "<None Selected>"
        let completed = false
        let locked = false
        let simulations = 0
        let aggScore = 0
        
        self.init(name: thisName, chosenTeams: chosenTeams, winner: winner, completed: completed, locked: locked, simulations: simulations, aggScore: aggScore)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let chosenTeams = aDecoder.decodeObject(forKey: "chosenTeams") as? [Int],
              let winner = aDecoder.decodeObject(forKey: "winner") as? String
            else{
                  return nil
              }
        let locked = aDecoder.decodeBool(forKey: "locked") as Bool
        let completed = aDecoder.decodeBool(forKey: "completed") as Bool
        let simulations = aDecoder.decodeInteger(forKey: "simulations")
        let aggScore = aDecoder.decodeInteger(forKey: "aggScore")

        self.init(name: name, chosenTeams: chosenTeams, winner: winner, completed: completed, locked: locked, simulations: simulations, aggScore: aggScore)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.chosenTeams, forKey: "chosenTeams")
        coder.encode(self.winner, forKey: "winner")
        coder.encode(self.completed, forKey: "completed")
        coder.encode(self.locked, forKey: "locked")
        coder.encode(self.simulations, forKey: "simulations")
        coder.encode(self.aggScore, forKey: "aggScore")
    }
        
    func setName(name: String){
        self.name = name        
    }
    
    func includeNewSim(score: Int){
        self.simulations += 1
        self.aggScore += score
    }
    
    func convertMatchToScore(placeInArray: Int) ->Int {
        if placeInArray >= 31{
            return 10
        }
        else if placeInArray >= 15{
            return 20
        }
        else if placeInArray >= 7{
            return 40
        }
        else if placeInArray >= 3{
            return 80
        }
        else if placeInArray >= 1{
            return 160
        }
        else if placeInArray == 0{
            return 320
        }
        else{
            print("Weird index passed. Check what's going on")
            return 0
        }
    }
    
    func getScore(simulationResults: [Int]) -> Int {
        var cumScore = 0
        for ind in 0...62{
            print("\nFor game id \(ind) we have:")
            
            print("Bracket entry with: \(DataManager.sharedInstance.teams[self.chosenTeams[ind]].name)")
            print("Simulation with : \(DataManager.sharedInstance.teams[simulationResults[ind]].name)")
            if self.chosenTeams[ind] == simulationResults[ind]{
                cumScore += convertMatchToScore(placeInArray: ind)
                print("This yields \(convertMatchToScore(placeInArray: ind)) points")
            }
            else{
                print("This yields 0 points")
            }
            
        }
        return cumScore
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
        if winnerID >= 0{
            return DataManager.sharedInstance.teams[winnerID].name
        }
        else{ return "<None Selected>"}
    }
        
    func lockBracket(){
        self.locked = true
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