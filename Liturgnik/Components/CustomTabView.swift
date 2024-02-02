//
//  CustomTabView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selection: Int
    var content: [Any]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CustomTabView(selection: .constant(1), content: [
    Text("Test"), Text("S")])
}
