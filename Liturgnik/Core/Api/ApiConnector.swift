//
//  ApiConnector.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 09/01/2024.
//

import Foundation

struct Message: Codable {
    let id: Int
    let title: String
    let content: String
}

struct Event: Codable {
    let id: Int
}

struct Mszal: Codable {
    let id: Int
    let dateFrom: String
    let dateTo: String
    let formulatrz: String
    let prefacja: [String]
    let modlitwa: String
}

struct DataModel: Codable {
    let messages: [Message]
    let events: [Event]
    let mszal: [Mszal]
    
}

class ApiConnector{
    static let shared = ApiConnector()
    
    private let apiUrl: String = "https://raw.githubusercontent.com/xybl3/Liturgnik/main/Data.json";
    
    func fetchData() async -> Void {
        guard let url = URL(string: apiUrl) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(DataModel.self, from: data)
            
            print("decoded data: \(decodedData)")
            
        } catch {
            print("error \(error)")
        }
        
    }
    
//    private var
}
