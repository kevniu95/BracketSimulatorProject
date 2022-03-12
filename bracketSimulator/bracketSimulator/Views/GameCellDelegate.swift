//
//  GameCellDelegate.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/9/22.
//

import Foundation

protocol GameCellDelegate: AnyObject{
    func setNewTeam(team: Team, nextGame: Int)
    func resetDownstreamCells(team: Team, nextGames: [Int], prevTeam: Team)
    func presentAlert(currCellTeam: Team, currCellID: Int, nextGames: [Int])
}
