//
//  Teams.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import Foundation
import UIKit


enum Keys: String{
    case teamid = "teamid"
}

class Team {
    var teamid: Int
    var binID: String
    var firstCellID: Int
    var name: String
    var seed: Int
    var image: UIImage
//    var image: UIImage
    
    init(teamid: Int, binID: String, firstCellID: Int, name: String, seed: Int, image: UIImage){
        self.teamid = teamid
        self.binID = binID
        self.firstCellID = firstCellID
        self.name = name
        self.seed = seed
        self.image = image
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

func initiateTeams(numTeams: Int) -> [Int]{
    var chosenTeams = [Int]()
    let index = numTeams - 1
    for _ in 0...index{
        let blankTeamEntry = blankTeam().teamid
        chosenTeams.append(blankTeamEntry)
    }
    return chosenTeams
}

func blankTeam() -> Team{
    return Team(teamid: -1, binID: "-1", firstCellID: -1, name: "-1", seed: 0, image: UIImage())
}

func convertTeams() -> [Team] {
    var teams = [Team]()

    //locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "2022teams", ofType: "csv") else {
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
             if columns.count == 6 {
                 let teamid = Int(columns[0]) ?? 0
                 let binID = pad(string: columns[1], toSize: 7)
                 let firstCellID = Int(columns[2]) ?? 0
                 let name = String(columns[3].filter{!"\n\t\r".contains($0)})
                 let seed = Int(String(columns[4].filter{!"\n\t\r".contains($0)})) ?? 0
                 let urlString = String(columns[5].filter{!"\n\t\r".contains($0)})
                 
                 
                 
                 if DataManager.sharedInstance.images.count > 0{
                     let savedImages = DataManager.sharedInstance.images
                     let image = savedImages[teamid]
                     if let image = image{
                         let team = Team(teamid: teamid, binID: binID, firstCellID: firstCellID, name: name, seed: seed, image: image)
                         teams.append(team)
                     }
                 }
                 else{
                     DataManager.sharedInstance.hadToPullNewImage = true
                     let url = URL(string: urlString)!
                     let data = try? Data(contentsOf: url)
                    
                     if let imageData = data {
                         let image = UIImage(data: imageData)!
                         DataManager.sharedInstance.images[teamid] = image
                         let team = Team(teamid: teamid, binID: binID, firstCellID: firstCellID, name: name, seed: seed, image: image)
                         teams.append(team)
                     } else{
                         let altImg = UIImage(systemName: "building.columns.circle")
                         let team = Team(teamid: teamid, binID: binID, firstCellID: firstCellID, name: name, seed: seed, image: altImg!)
                         teams.append(team)
                     }
                 }
             }
         }
    return teams
}
