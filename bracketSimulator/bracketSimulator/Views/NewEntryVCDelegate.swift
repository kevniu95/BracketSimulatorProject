//
//  NewEntryVCDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

protocol NewEntryVCDelegate: AnyObject{
    func saveEntry(entryName: String, entry: BracketEntry)
}
