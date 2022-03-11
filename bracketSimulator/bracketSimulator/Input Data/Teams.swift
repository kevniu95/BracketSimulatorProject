//
//  Teams.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import Foundation


class Team: NSObject, NSCoding {
    var id: Int
    var binID: String
    var firstCellID: Int
    var name: String
    var seed: Int
//    var image: UIImage
    
    init(id: Int, binID: String, firstCellID: Int, name: String, seed: Int){
        self.id = id
        self.binID = binID
        self.firstCellID = firstCellID
        self.name = name
        self.seed = seed
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? Int,
              let binID = aDecoder.decodeObject(forKey: "binID") as? String,
              let firstCellID = aDecoder.decodeObject(forKey: "firstCellID") as? Int,
              let name = aDecoder.decodeObject(forKey: "name") as? String,
              let seed = aDecoder.decodeObject(forKey: "seed") as? Int else{
                  return nil
              }
        self.init(id: id, binID: binID, firstCellID: firstCellID, name: name, seed: seed)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.binID, forKey: "binID")
        coder.encode(self.firstCellID, forKey: "firstCellID")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.seed, forKey: "seed")
    }
        
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

func initiateTeams(numTeams: Int) -> [Team]{
    var chosenTeams = [Team]()
    let index = numTeams - 1
    for _ in 0...index{
        let blankTeamEntry = blankTeam()
        chosenTeams.append(blankTeamEntry)
    }
    return chosenTeams
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


