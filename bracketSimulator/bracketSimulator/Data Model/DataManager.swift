//
//  DataManager.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/11/22.
//

import Foundation
import UIKit
class DataManager {
    //
    // MARK: - Singleton
    //
    public static let sharedInstance = DataManager()
    fileprivate init() {}
  
    var bracketEntries: [String: BracketEntry] = [:]
    var teams = [Team]()
    var gamePositions = [gamePosition]()
    var gameCells = [GameCell]()
  
    func archiveEntries() {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        print("I am about to save to this location: \(url)")
        do{
//            for bracketEntry in Array(bracketEntries.values){
//                for team in bracketEntry.chosenTeams{
//                    if team.id > 0{
//                        print(team.id)
//                    }
//                }
//            }
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: bracketEntries, requiringSecureCoding: false)
            try data.write(to: url)
            print(data)
        } catch (let error){
            print("Error saving to file: \(error)")
        }
        print("Hey I just saved!")
    }
    
    func instantiateFixedData(){
        createTeams()
        createGamePositions()
        createGameCells()
    }
    
    func createTeams(){
        // Creates the list of 64 teams to be saved in singleton
        // (So don't have to create every time in NewEntry VC)
        self.teams = convertTeams()
    }
    
    func createGamePositions(){
        self.gamePositions = convertGamePositions()
    }
    
    func createGameCells(){
        for ind in 1...127{
            let gamePosition = gamePositions[ind - 1]
            let currGameCell = GameCell(idNum: ind, gamePos: gamePosition)
            gameCells.append(currGameCell)
        }
    }
        
    func unArchiveEntries() -> [String : BracketEntry] {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [:] }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        print("I am trying to load up the data and the url is \(url)")
        var entries: [String : BracketEntry]?
        do{
            let data = try Data(contentsOf: url)
            entries = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String : BracketEntry]
            print("Hey look I just pulled up some files")
            print(entries)
        } catch (let error){
            print("Error fetching from file: \(error)")
        }
        if let entries = entries{
            self.bracketEntries = entries
        }
        return entries ?? [:]
    }
    
    // Update entry from bracketEntries
    // Save out the update as well everytime there is an update
    func updateEntries(entryName: String, bracketEntry: BracketEntry){
        bracketEntries[entryName] = bracketEntry
        print("Updated set of entries in DataManager and will save them out")
//        for bracketEntry in Array(bracketEntries.values){
//            print(bracketEntry)
//            for j in bracketEntry.chosenTeams {
//                print(j)
//            }
//        }
        archiveEntries()
    }
    
    func removeFromEntries(_ bracketEntry: BracketEntry){
//        if let index = bracketEntries.firstIndex(of: bracketEntry){
//            bracketEntries.remove(at: index)
//            print(userFavorites)
//        }
    }

}
