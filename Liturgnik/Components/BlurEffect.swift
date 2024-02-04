//
//  BlurEffect.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 04/02/2024.
//

import Foundation
import SwiftUI
import UIKit

struct BlurEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style = .regular
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
