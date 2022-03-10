//
//  Teams.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import Foundation


struct Team {
    var id: Int
    var binID: String
    var firstCellID: Int
    var name: String
    var seed: Int
//    var image: UIImage
}

func convertToBin(num: Int, toSize: Int) -> String{
    let tmpStr = String(num, radix: 2)
    return pad(string: tmpStr, toSize: toSize)
}

func pad(string : String, toSize: Int) -> String {
  var padded = string
    while padded.count < toSize{
        padded = "0" + padded
    }
    return padded
}

func blankTeam() -> Team{
    return Team(id: -1, binID: "", firstCellID: -1, name: "", seed: 0)
}

func convertTeams() -> [Team] {
    var teams = [Team]()

    //locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "2021teams", ofType: "csv") else {
        print("Didn't find csv")
        return []
    }
    
    //convert that file into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return []
    }

    //now split that string into an array of "rows" of data.  Each row is a string.
    var rows = data.components(separatedBy: "\n")
    
    //if you have a header row, remove it here
    rows.removeFirst()
    //now loop around each row, and split it into each of its columns
         for row in rows {
             let columns = row.components(separatedBy: ",")

             //check that we have enough columns
             if columns.count == 5 {
                 let id = Int(columns[0]) ?? 0
                 let binID = pad(string: columns[1], toSize: 7)
                 let firstCellID = Int(columns[2]) ?? 0
                 let name = String(columns[3].filter{!"\n\t\r".contains($0)})
                 let seed = Int(String(columns[4].filter{!"\n\t\r".contains($0)})) ?? 0
                 let team = Team(id: id, binID: binID, firstCellID: firstCellID, name: name, seed: seed)
                 teams.append(team)
                 
             }
         }
    return teams
}


