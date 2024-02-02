//
//  Liturgy.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import Foundation

enum VestmentColor {
    case red
    case white
    case purple
    case pink
    case green
    case other(String)
    
    var value: String {
        switch self {
        case .red:
            return "Czerwony"
        case .white:
            return "Biały"
        case .purple:
            return "Fioletowy"
        case .pink:
            return "Różowy"
        case .green:
            return "Zielony"
        case .other(let string):
            return string
        }
    }
    
    
    
    static func fromString(inputStr: String) -> Self {
        switch inputStr {
        case "czerwony":
            return .red
        case "biały":
            return .white
        case "fioletowy":
            return .purple
        case "różowy":
            return .pink
        case "zielony":
            return .green
        case _:
            return .other(inputStr)
        }
    }
}
