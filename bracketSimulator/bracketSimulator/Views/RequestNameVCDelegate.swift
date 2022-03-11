//
//  RequestNameVCDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/10/22.
//

import Foundation

protocol RequestNameVCDelegate: AnyObject{
    func saveNewEntry(entryName: String, entry: BracketEntry)
}
