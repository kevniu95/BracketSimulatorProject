//
//  BracketEntry.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

class BracketEntry{
    private (set) var id: Int
    private (set) var name: String
    private (set) var chosenTeams: [Team]
    
    init(id : Int, name: String){
        self.id = id
        self.name = name
        self.chosenTeams = [Team]()
        
        self.initiateTeams()
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
        for team in self.chosenTeams{
            if team.id > -1{
                print(String(i))
                print(team)
            }
            i += 1
        }
    }
    
}
