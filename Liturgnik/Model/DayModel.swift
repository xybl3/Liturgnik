//
//  DayModel.swift
//  Niedziela
//
//  Created by Olivier Marszałkowski on 06/01/2024.
//

import Foundation


enum VestmentColor: Codable, Hashable {
    case red
    case white
    case purple
    case pink
    case green
    case other(String)
    
    func toString() -> String{
        switch(self){
        case .green: return "Zielony"
        case .pink: return "Różowy"
        case .purple: return "Fioletowy"
        case .white: return "Bialy"
        case .red: return "Czerwony"
        case .other(let other): return other
        }
    }
    
    static func fromString(inputStr: String) -> Self{
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

