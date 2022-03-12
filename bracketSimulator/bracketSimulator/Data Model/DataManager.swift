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
    var simulations = [SimulationBasic]()
    var images = [UIImage]()
  
    func archiveEntries() {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: bracketEntries, requiringSecureCoding: false)
            try data.write(to: url)
            print(data)
        } catch (let error){
            print("Error saving to file: \(error)")
        }
    }
    
    func shareTeams() -> [Team]{
        return self.teams
    }

    func scoreSimulations(){
        for simulation in simulations{
            for (entryName, bracketEntry) in bracketEntries{
                if bracketEntry.completed{
                    let thisScore = bracketEntry.getScore(simulationResults: simulation.arrayToScore)
                    bracketEntry.includeNewSim(score: thisScore)
                }
            }
        }
    }
    func runSimulations(n: Int){
        for _ in 1...n{
            let sim = SimulationBasic()
            sim.fillGames()
            simulations.append(sim)
        }
        scoreSimulations()
        archiveEntries()
        
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
        print(bracketEntry.locked)
        archiveEntries()
    }
    
    func formatInt(val: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:val))
        if let formattedNumber = formattedNumber{
            return formattedNumber
        }
        else{
            print("Woops, couldn't format number!")
            return "???"
        }
        
    }
    
    func removeFromEntries(bracketEntry: BracketEntry){
        bracketEntries.removeValue(forKey: bracketEntry.name)
        print("Updated entries by deleting \(bracketEntry.name). Saving out changes")
        archiveEntries()
    }

}
