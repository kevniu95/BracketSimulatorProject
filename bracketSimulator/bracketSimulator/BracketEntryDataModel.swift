//
//  BracketEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

class BracketEntry{
//    private (set) var id: Int
    private (set) var name: String
    private (set) var chosenTeams: [Team]
    private (set) var winner: String
    private (set) var scores: [Float]
    private (set) var recentScore: Float
    
    init(name: String){
//        self.id = id
        self.name = name
        self.chosenTeams = [Team]()
        self.winner = ""
        self.recentScore = 0
        self.scores = [Float]()
        
        self.initiateTeams()
    }
    
    func setName(name: String){
        self.name = name        
    }
    
    func initiateTeams(){
        let initialTeam = Team(id: -1, binID: "", firstCellID: -1, name: "", seed: 0)
        for _ in 0...63{
            chosenTeams.append(initialTeam)
        }
    }
    
    func updateTeams(gameID: Int, newTeam: Team){
        self.chosenTeams[gameID] = newTeam
        var i = 0
        print("\nBracket Entry chosen teams have been updated:")
        for team in self.chosenTeams{
            if team.id > -1{
                let gameid = i + 1
                print("Game ID \(gameid) has been filled with \(team.name)")
            }
            i += 1
        }
        if gameID == 1{
            self.winner = newTeam.name
        }
    }
    
}
