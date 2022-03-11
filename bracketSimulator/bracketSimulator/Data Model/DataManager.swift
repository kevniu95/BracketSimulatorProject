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
    
//    "//Users/kniu91/Library/Developer/CoreSimulator/Devices/74A7AD40-7D35-43EE-8DCD-772AFA3588B9/data/Containers/Data/Application/D1B9577E-0314-476E-B0C4-1F66B92CAAF2/Documents/bracketEntries.plist"
    
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
    
    func updateEntries(entryName: String, bracketEntry: BracketEntry){
        bracketEntries[entryName] = bracketEntry
        print("Updated set of entries. Entries are now")
        for i in bracketEntries{
            print(i)
        }
    }
    
    func removeFromEntries(_ bracketEntry: BracketEntry){
//        if let index = bracketEntries.firstIndex(of: bracketEntry){
//            bracketEntries.remove(at: index)
//            print(userFavorites)
//        }
    }

}
