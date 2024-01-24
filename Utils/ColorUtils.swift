//
//  ColorUtils.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 24/01/2024.
//

import SwiftUI

class ColorUtils {
    static func getTextColorBasedOnVestureColor(for vestmentColor: VestmentColor, in colorScheme: ColorScheme) -> Color {
        let textColor: Color
        switch vestmentColor {
            case .green: textColor = .green
            case .pink: textColor = .pink
            case .purple: textColor = .purple
            case .red: textColor = .red
            case .white: textColor = .white
        case .other: textColor =  colorScheme == .light ? .black : .white
        }
        
        if textColor == .white && colorScheme == .light {
            return .black
        }
        
        return textColor
    }
}
