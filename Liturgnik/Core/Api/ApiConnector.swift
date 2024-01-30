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
    let formularz: String
    let prefacja: [String]
    let modlitwa: String
    let wyjatki: [Wyjatek]?
}

/// Wyjatek to wyjatek w jsonie, uzywany, kiedy jest jakieś swieto lub wspomnienie, gdzie do skruktury ``Mszal`` trzeba zmienic formularz
struct Wyjatek: Codable {
    let id: Int
    let formularz: String
    let prefacja: [String]
    let modlitwa: String
}

/// 
struct DataModel: Codable {
    let messages: [Message]
    let events: [Event]
    let mszal: [Mszal]
    
}

class ApiConnector{
    static let shared = ApiConnector()
    
    private var fileData: DataModel? = nil
    
    private let apiUrl: String = "https://raw.githubusercontent.com/xybl3/Liturgnik/main/Data.json";
    
    init() {
        print("🚀 Initializing ApiConnector")
    }
    
    func fetchData() async -> Void {
        guard let url = URL(string: apiUrl) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(DataModel.self, from: data)
            
//            print("decoded data: \(decodedData)")
            print("📖 Recived data from api")
            
            fileData = decodedData
            
        } catch {
            print("error \(error)")
        }
    }
    
    func getMszal() -> [Mszal]? {
        
        return fileData?.mszal
    }
}
