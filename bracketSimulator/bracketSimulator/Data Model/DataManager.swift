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
  
    
    // MARK: Read and write
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
    func unArchiveEntries(){
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        var entries: [String : BracketEntry]?
        do{
            let data = try Data(contentsOf: url)
            entries = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String : BracketEntry]
        } catch (let error){
            print("Error fetching from file: \(error)")
        }
        if let entries = entries{
            self.bracketEntries = entries
        }
        return
    }
    
    // MARK: Run and Score Simulations
    func scoreSimulations(){
        for simulation in simulations{
            for (_, bracketEntry) in bracketEntries{
                if bracketEntry.locked{
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
    
    
    // MARK: Instantiate and share DataManager info
    func shareTeams() -> [Team]{
        return self.teams
    }
    
    func instantiateFixedData(){
        createTeams()
        createGamePositions()
        createGameCells()
        unArchiveEntries()
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
        
    
    // MARK: Manage updates to and from Data Manager - will be automatically archived
    // Update entry from bracketEntries
    // Save out the update as well everytime there is an update
    func updateEntries(entryName: String, bracketEntry: BracketEntry){
        bracketEntries[entryName] = bracketEntry
        print("Updated set of entries in DataManager and will save them out")
        print(bracketEntry.locked)
        archiveEntries()
    }
    
    func removeFromEntries(bracketEntry: BracketEntry){
        bracketEntries.removeValue(forKey: bracketEntry.name)
        print("Updated entries by deleting \(bracketEntry.name). Saving out changes")
        archiveEntries()
    }
    
    // MARK: Utility function
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
}
