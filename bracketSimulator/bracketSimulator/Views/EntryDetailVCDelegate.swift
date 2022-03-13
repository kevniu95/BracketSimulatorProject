//
//  EntryDetailVCDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/13/22.
//

import Foundation

protocol EntryDetailVCDelegate: AnyObject{
    func saveDetailEntry(entryName: String, entry: BracketEntry)
}
