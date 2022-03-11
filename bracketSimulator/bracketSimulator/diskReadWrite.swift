//
//  diskReadWrite.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/11/22.
//

import Foundation


func archiveEntries(_ bracketEntries: [BracketEntry]) {
    guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let url = docDirectory.appendingPathComponent("bracketEntries.plist")
    print("I am about to save to this location: \(url)")
    do{
        let data = try NSKeyedArchiver.archivedData(withRootObject: bracketEntries, requiringSecureCoding: false)
        try data.write(to: url)
        print(data)
    } catch (let error){
        print("Error saving to file: \(error)")
    }
    print("Hey I just saved!")
}

func unArchiveEntries() -> [BracketEntry] {
    guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
    let url = docDirectory.appendingPathComponent("bracketEntries.plist")
    print("I am trying to load up the data and the url is \(url)")
    var entries: [BracketEntry]?
    do{
        let data = try Data(contentsOf: url)
        entries = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [BracketEntry]
    } catch (let error){
        print("Error fetching from file: \(error)")
    }
    print("Hey look I just pulled up some files")
    print(entries)
    return entries ?? []
}
