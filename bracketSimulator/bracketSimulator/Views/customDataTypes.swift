//
//  customDataTypes.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/22/22.
//

import Foundation



enum Round: Int, CaseIterable{
    case first = 0, second, third, quarters, semis, final
    
    func getString() -> String{
        switch self{
        case.first:
            return "Round of 64"
        case.second:
            return "Round of 32"
        case.third:
            return "Sweet Sixteen"
        case.quarters:
            return "Elite Eight"
        case.semis:
            return "Final Four"
        case.final:
            return "Championship"
        }
    }
    func getEndPoints() -> [Int]{
        switch self{
        case.first:
            return [31, 62]
        case.second:
            return [15, 30]
        case.third:
            return [7, 14]
        case.quarters:
            return [3, 6]
        case.semis:
            return [1, 2]
        case.final:
            return [0, 0]
        }
    }
}
