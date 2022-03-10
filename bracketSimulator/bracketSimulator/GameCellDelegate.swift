//
//  GameCellDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import Foundation

protocol GameCellDelegate: AnyObject{
    func highlightNextGames(_ nextGames: [Int])
    func unhighlightNextGames(_ nextGames: [Int])
    func setNewTeam(team: Team, nextGame: Int)
    func resetDownStreamCells(team: Team, nextGames: [Int])
}
