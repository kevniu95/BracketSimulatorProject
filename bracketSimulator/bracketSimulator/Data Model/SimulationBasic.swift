//
//  BasicSimulator.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/11/22.
//

import Foundation

public extension Float {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
}

// MARK: Game class to support simulations
class Game{
    var team1: Team
    var team2: Team?
    var winner: Team
    
    init(){
        self.team1 = blankTeam()
        self.team2 = nil
        self.winner = blankTeam()
        rearrangeTeams()
    }
    
    // MARK: Set up game
    // Note that as soon as team as are filled, game is simulated
    //   and winner is produced
    func fillTeams(team1: Team, team2: Team?){
        self.team1 = team1
        guard let team2 = team2 else{
            self.winner = simulateGame()
            return
        }
        self.team2 = team2
        self.winner = simulateGame()
    }
    
    func rearrangeTeams(){
        guard let team2 = self.team2 else{
            return
        }
        if self.team1.seed > team2.seed{
            let tmp = self.team2!
            self.team2 = self.team1
            self.team1 = tmp
        }
    }
    
    // MARK: Simulate game
    func simulateGame() -> Team{
        guard let team2 = self.team2 else{
            return self.team1
        }
        let team1Advance = team1Odds()
        let randomVal = Float.random
        
//        print()
//        print("\(team1.name) is playing \(team2.name) and has \(team1Advance*100)% chance of advancing")
//        print("Random value give \(randomVal)")
        
        if randomVal < team1Advance{
            return team1
        } else {return team2}
    }
    
    // simulateGame helper function
    // Use linear equation based on seed difference for basic simulation model
    func team1Odds() -> Float {
        guard let team2 = self.team2 else{
            return 1
        }
        let seedDiff = Float(self.team1.seed - team2.seed)
        if seedDiff >= -1{
            return 0.5
        }
        else{
            return -0.0339 * seedDiff + 0.4774
        }
    }
    
}

// MARK: Simulation Class to run simulations
class SimulationBasic{
    var teams = [Team]()
    var allGames = [Game]()
    var winner: Team
    var arrayToScore: [Int]
    
    init(){
        self.teams = DataManager.sharedInstance.shareTeams()
        self.winner = blankTeam()
        self.arrayToScore = []
        //        for team in teams{
//            print("\(team.name) \(team.teamid)")
//        }
    }
    
    // Creates an array to be scored
    func createBlankGames(){
        for _ in 0...127{
            allGames.append(Game())
        }
        for ind in 63...126{
            let team1 = self.teams[ind - 63]
            allGames[ind].fillTeams(team1: team1, team2: nil)
        }
    }
    
    // Fills Array to be scored, lets Games class do calculations
    // Then passes winner on to next game
    func fillGames(){
        createBlankGames()
        var ind = 62
        while ind >= 0 {
            let tm1 = allGames[ind * 2 + 1].winner
            let tm2 = allGames[ind * 2 + 2].winner
            allGames[ind].fillTeams(team1: tm1, team2: tm2)
            ind -= 1
        }
        self.winner = allGames[0].winner
        self.arrayToScore = genArrayForScoring()
    }
    
    // Instantiates an array to be scored
    // This is where simulation is "run"
    // Winners determined in Game-class objects
    func genArrayForScoring() -> [Int] {
        var arrayToScore = [Int]()
        for ind in 0...62{
            arrayToScore.append(allGames[ind].winner.teamid)
        }
        return arrayToScore
    }
    
}
