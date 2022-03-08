//
//  csvReader.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/8/22.
//

import Foundation


struct gameLocation {
    var id: Int
    var x: Float
    var y: Float
}

func convertGameLocations() -> [gameLocation] {
    var gameLocations = [gameLocation]()

    //locate the file you want to use
    guard let filepath = Bundle.main.path(forResource: "gameCellPositions", ofType: "csv") else {
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
             if columns.count == 3 {
                 let id = Int(columns[0]) ?? 0
                 let x = Float(columns[1]) ?? 0.0
                 let y = Float(String(columns[2].filter { !" \n\t\r".contains($0) })) ?? 0.0
                 let gameLocation = gameLocation(id: id, x: x, y: y)
                 gameLocations.append(gameLocation)
             }
         }
    return gameLocations
}


