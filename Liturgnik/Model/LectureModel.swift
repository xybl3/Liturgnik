//
//  LectureModel.swift
//  Niedziela
//
//  Created by Olivier Marszałkowski on 06/01/2024.
//

import Foundation



protocol Readable: Identifiable {
    var content: String { get }
}

protocol Singable: Identifiable {
    var chorus: String { get }
    var verses: [String] { get }
}

struct Lecture: Readable {
    let id: Int
    let sigle: String // Ex. Iz 60, 1-6
    let heading: String // Ex. Czytanie z Księgi proroka Izajasza
    let content: String // Content of lecture
}

struct Psalm: Singable {
    let id: Int // Id, for example when is more thatn one psalm
    let chorus: String // Ex. Uwielbią Pana wszystkie ludy ziemi
    let verses: [String] // List of all verses in that psalm
}

struct Acclamation: Singable {
    var id: Int
    var chorus: String
    var verses: [String]
}
