//
//  DayModel.swift
//  Niedziela
//
//  Created by Olivier Marszałkowski on 06/01/2024.
//

import Foundation


enum VestmentColor {
    case red
    case white
    case purple
    case pink
    case green
    case other(String)
    
    func toString()->String{
        switch(self){
        case .green: return "Zielony"
        case .pink: return "Różowy"
        case .purple: return "Fioletowy"
        case .white: return "Bialy"
        case .red: return "Czerwony"
        case .other(let other): return other
        }
    }
    
//    static fromString(inputStr: String){
//        switch inputStr {
//            
//        }
//    }
}

struct NormalDay {
    let date: Date
    let vestmentColor: VestmentColor
    let lectures: [Lecture]
    let psalm: Psalm
    let gospel: Lecture
    
}

struct SunDay {
    
}
