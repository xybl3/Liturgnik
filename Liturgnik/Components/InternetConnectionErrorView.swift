//
//  InternetConnectionErrorView.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 05/02/2024.
//

import SwiftUI

struct InternetConnectionErrorView: View {
    var body: some View {
        VStack {
            
            Image(systemName: "cloud")
                .font(.system(size: 100))
                .foregroundColor(.gray)
                .padding(.top, 50)
            
            Text("Brak połączenia API.\nSprawdź swoje połączenie z internetem.")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    InternetConnectionErrorView()
}
