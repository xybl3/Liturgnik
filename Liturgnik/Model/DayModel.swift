//
//  DayModel.swift
//  Niedziela
//
//  Created by Olivier Marszałkowski on 06/01/2024.
//

import Foundation


enum VestmentColor: String {
    case red = "Czerwony"
    case white = "Biały"
    case purple = "Fioletowy"
    case pink = "Różowy"
    case green = "Zielony"
    case other
    
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
