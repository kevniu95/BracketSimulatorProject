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
    private (set) var initDate: Date
    private (set) var lockDate: Date?
    var lastEdit: Date
    private (set) var recentSims = [[Int]]()
    private (set) var recentScores = [Int]()
    
    init(name: String, chosenTeams: [Int], winner: String, completed: Bool, locked: Bool, simulations: Int, aggScore: Int, initDate: Date, lockDate: Date?, lastEdit: Date, recentSims: [[Int]], recentScores: [Int]){
        self.name = name
        self.chosenTeams = chosenTeams
        self.winner = winner
        self.completed = completed
        self.locked = locked
        self.simulations = simulations
        self.aggScore = aggScore
        self.initDate = initDate
        self.lockDate = lockDate
        self.lastEdit = lastEdit
        self.recentSims = recentSims
        self.recentScores = recentScores
    }
    
    convenience init(name: String, chosenTeams: [Int], winner: String, completed: Bool, recentSims: [[Int]]){
        let locked = false
        let simulations = 0
        let aggScore = 0
        let initDate = Date()
        var lockDate: Date?
        lockDate = nil
        let lastEdit = Date()
        let recentScores = [Int]()
        self.init(name: name, chosenTeams: chosenTeams, winner: winner, completed: completed, locked: locked, simulations: simulations, aggScore: aggScore, initDate: initDate, lockDate: lockDate, lastEdit: lastEdit, recentSims: recentSims, recentScores: recentScores)
    }
    
    convenience init(name: String){
        let thisName = name
        let chosenTeams = initiateTeams(numTeams: 64)
        let winner = "<None>"
        let completed = false
        let locked = false
        let simulations = 0
        let aggScore = 0
        let initDate = Date()
        var lockDate: Date?
        lockDate = nil
        let lastEdit = Date()
        let recentSims = [[Int]]()
        let recentScores = [Int]()
        self.init(name: thisName, chosenTeams: chosenTeams, winner: winner, completed: completed, locked: locked, simulations: simulations, aggScore: aggScore, initDate: initDate, lockDate: lockDate, lastEdit: lastEdit, recentSims: recentSims, recentScores: recentScores)
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
        var initDate: Date
        if let importDate = aDecoder.decodeObject(of: NSDate.self, forKey: "initDate"){
            initDate = importDate as Date
        } else {initDate = Date()}
        let lockDate = aDecoder.decodeObject(of: NSDate.self, forKey: "lockDate") as Date?
        var lastEdit: Date
        if let importLastEdit = aDecoder.decodeObject(of: NSDate.self, forKey: "lastEdit"){
            lastEdit = importLastEdit as Date
        } else {lastEdit = Date()}
        
        var recentSims: [[Int]]
        if let mostRecentSims = aDecoder.decodeObject(forKey: "recentSims") as? [[Int]]{
            recentSims = mostRecentSims
        } else{recentSims = []}

        self.init(name: name, chosenTeams: chosenTeams, winner: winner, completed: completed, locked: locked, simulations: simulations, aggScore: aggScore, initDate: initDate, lockDate: lockDate, lastEdit: lastEdit, recentSims: recentSims, recentScores: [Int]())
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.chosenTeams, forKey: "chosenTeams")
        coder.encode(self.winner, forKey: "winner")
        coder.encode(self.completed, forKey: "completed")
        coder.encode(self.locked, forKey: "locked")
        coder.encode(self.simulations, forKey: "simulations")
        coder.encode(self.aggScore, forKey: "aggScore")
        coder.encode(self.initDate, forKey: "initDate")
        coder.encode(self.lockDate, forKey: "lockDate")
        coder.encode(self.lastEdit, forKey: "lastEdit")
        coder.encode(self.recentSims, forKey: "recentSims")
    }
        
    func setName(name: String){
        self.name = name        
    }
    
    func includeNewSim(score: Int){
        self.simulations += 1
        self.aggScore += score
    }
    
    
    func getScore(simulationResults: [Int], saveMe: Bool) -> Int {
        var cumScore = 0

        let chosenRes = self.chosenTeams
        let scores = DataManager.sharedInstance.getScoreGeneral(chosenTeamSet: chosenRes, simulationTeamSet: simulationResults)
        
        cumScore = scores.reduce(0, +)
        
        if saveMe{saveToRecentSims(simResultsIntList: simulationResults)}
        
        return cumScore
    }
    
    func saveToRecentSims(simResultsIntList: [Int]){
        self.recentSims.append(simResultsIntList)
        self.recentSims = recentSims.suffix(50)
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
        else{ return "<None>"}
    }
        
    func lockBracket(){
        self.locked = true
        self.lockDate = Date()
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
