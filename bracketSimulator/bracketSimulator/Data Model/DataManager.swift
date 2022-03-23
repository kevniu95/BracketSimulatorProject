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
    var images = [Int:UIImage]()
    var mostRecentDetailEntry = BracketEntry(name: "-1")
    var hadToPullNewImage = false
    private(set) var timesOpened = -1
    
    // MARK: App metadata
    func updateTimesOpened(timesOpened: Int){
        self.timesOpened = timesOpened
    }
    
    
    // MARK: Read and write
    func archiveTeamImages(){
        print("\nI am archiving the team images right now to: ")
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("teamImages.plist")
        print(url)
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: false)
            try data.write(to: url)
            print(data)
        } catch (let error){
            print("Error saving to file: \(error)")
        }
    }
    
    func unarchiveTeamImages(){
        print("\nI am pulling the team images from disk right now from:")
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("teamImages.plist")
        print(url)
        var entries: [Int : UIImage]?
        do{
            let data = try Data(contentsOf: url)
            entries = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Int : UIImage]
        } catch (let error){
            print("Error fetching from file: \(error)")
        }
        if let entries = entries{
            self.images = entries
        }
        return
    }
    
    func archiveEntries() {
        print("\nI am saving bracket entries right now to:")
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        print(url)
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: bracketEntries, requiringSecureCoding: false)
            try data.write(to: url)
            print(data)
        } catch (let error){
            print("Error saving to file: \(error)")
        }
    }
    func unArchiveEntries(){
        print("\nI am loading bracket entries right now from:")
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docDirectory.appendingPathComponent("bracketEntries.plist")
        print(url)
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
        self.unarchiveTeamImages()
        self.teams = convertTeams()
        if hadToPullNewImage{
            self.archiveTeamImages()
        }
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
        
    // MARK: Run and Score Simulations
    func scoreSimulations(){
        for simulation in simulations{
            for (_, bracketEntry) in bracketEntries{
                if bracketEntry.locked{
                    print("I am scoring")
                    let simArray = simulation.arrayToScore
                    let thisScore = bracketEntry.getScore(simulationResults: simArray, saveMe: true)
                    bracketEntry.includeNewSim(score: thisScore)
                }
            }
        }
    }
    
    func setRecentDetailEntry(entry: BracketEntry){
        self.mostRecentDetailEntry = entry
    }
    
    func getRecentDetailEntry() -> BracketEntry{
        return mostRecentDetailEntry
    }
    
    func runSimulations(n: Int){
        for _ in 1...n{
            let sim = SimulationBasic()
            sim.fillGames()
            simulations.append(sim)
        }
        scoreSimulations()
        
        // Need to reset simulations array to be empty so not cumulatively
        // counting them over and over
        simulations = []
        archiveEntries()
    }
    
    // Score Simulations
    func convertMatchToScore(placeInArray: Int) ->Int {
        if placeInArray >= 31{
            return 10
        }
        else if placeInArray >= 15{
            return 20
        }
        else if placeInArray >= 7{
            return 40
        }
        else if placeInArray >= 3{
            return 80
        }
        else if placeInArray >= 1{
            return 160
        }
        else if placeInArray == 0{
            return 320
        }
        else{
            print("Weird index passed. Check what's going on")
            return 0
        }
    }
    
    func getScoreGeneral(chosenTeamSet: [Int], simulationTeamSet: [Int]) -> [Int]{
        var correctSelectionMask = [Int]()
        for ind in 0...62{
            if chosenTeamSet[ind] == simulationTeamSet[ind]{
                correctSelectionMask.append(convertMatchToScore(placeInArray: ind))
            }
            else{ correctSelectionMask.append(0)}
        }
        print(correctSelectionMask)
        return correctSelectionMask
    }
    
    
    
    
    // MARK: Manage updates to and from Data Manager - will be automatically archived
    // Update entry from bracketEntries
    // Save out the update as well everytime there is an update
    func updateEntries(entryName: String, bracketEntry: BracketEntry){
        bracketEntry.lastEdit = Date()
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
