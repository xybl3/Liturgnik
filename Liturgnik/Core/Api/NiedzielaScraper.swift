//
//  NiedzielaScraper.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 06/01/2024.
//

import Foundation
import SwiftSoup

enum ScrapingError: Error {
    case lectureCountZero
    case cannotGetDayOccasion(message: String)
    case vestmentColorError
    case sigleNotFound
}

class NiedzielaScraper: ObservableObject {
    
    static let shared = NiedzielaScraper()
    
    private var url: URL? = nil
    private var document: Document? = nil
    
    
    private init() {
        setDate(to: Date())
    }
    
    func setDate(to date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: date ?? Date())
        
        self.url = URL(string: "https://niezbednik.niedziela.pl/liturgia/\(formattedDate)")
    }
    
    func performScrape() async throws -> Void {
        if self.url == nil {
            setDate(to: Date())
        }
        
        let (data, _) = try await URLSession.shared.data(from: self.url!)
        
        let htmlData = String(data: data, encoding: .utf8)
        
        guard let htmlData = htmlData else {
            throw NSError(domain: "NiedzielaScraper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve data"])
        }
        
        self.document = try SwiftSoup.parse(htmlData)
        
        
    }
    
    func getLecturesLength() -> Result<Int, Error> {
        do {
            guard let doc = try document?.getElementById("elementyTabContent0") else {
                return .success(0)
            }
            
            let count = doc.children().count
            return .success(count - 1) // minus one because there is one div that takes all lectures
        } catch {
            return .failure(error)
        }
    }
    //*[@id="content"]/article/p[1]/em
    
    func getLectures() -> Result<[Any], Error>{
        
        guard case let .success(count) = self.getLecturesLength() else {
            return .failure(ScrapingError.lectureCountZero)
        }
        
        var lectures: [Any] = []
        for index in 0..<count {
            do {
                if let lecture = try self.document?.getElementById("tabnowy0\(index)") {
                    let sigle = try lecture.children().first()?.text()
                    
                    guard let sigle = sigle else {
                        print("Sigle was not found")
                        return .failure(ScrapingError.lectureCountZero)
                    }
                    
                    // T jest czytanie
                    if sigle.starts(with: /\d\./) {
                        let id = Int(Array(arrayLiteral: sigle)[0])
                        let withoutCzytanie = sigle
                            .replacingOccurrences(of: "czytanie", with: "")
                            .replacingOccurrences(of: "\(id ?? 0).", with: "")
                            .replacingOccurrences(of: ". ", with: "")
                            .replacingOccurrences(of: "(", with: "")
                            .replacingOccurrences(of: ")", with: "")
                            .trimmingCharacters(in: .whitespaces)
                        
                        var content = ""
                        
                        do {
                            let contentElements = try lecture.select("#tabnowy0\(index) > p")
                            
                            try contentElements.forEach { p in
                                content.append(try p.text() + "\n")
                            }
                        } catch {
                            print(error)
                        }
                        
                        
                        lectures.append(Lecture(id: id ?? 0, sigle: String(withoutCzytanie), heading: "", content: content))
                    }
                    else if sigle.starts(with: "Psalm") {
                        let chorus = try lecture.select("#tabnowy0\(index) > h4 > em").first()
                        guard let chorus = chorus else {
                            print("Chorus not found")
                            return .failure(ScrapingError.sigleNotFound)
                        }
                        
                        var verses: [String] = []
                        
                        for p in try lecture.select("#tabnowy0\(index) > p") {
                            let pText = try p.text()
                            let chorusText = try chorus.text()
                            
                            if pText != chorusText {
                                verses.append(pText)
                            }
                        }
                        
                        lectures.append(Psalm(id: index+1, chorus: try chorus.text(), verses: verses))
                        
                    }
                    
                    else if sigle.starts(with: "Aklamacja") {
                        
                        let chorus = try lecture.select("#tabnowy0\(index) > h4").text()
                        
                        var verses: [String] = []
                        
                        for v in try lecture.select("#tabnowy0\(index) > p:nth-child(4)") {
                            verses.append(try v.text())
                        }
                        
                        lectures.append(Acclamation(id: index+1, chorus: chorus, verses: verses))
                    }
                    else if sigle.starts(with: "Ewangelia"){
                        let rawSigle = sigle
                            .replacingOccurrences(of: "Ewangelia", with: "")
                            .replacingOccurrences(of: "(", with: "")
                            .replacingOccurrences(of: ")", with: "")
                            .trimmingCharacters(in: .whitespaces)
                        
                        var content: [String] = []
                        for p in try lecture.select("#tabnowy0\(index) > p") {
                            content.append(try p.text())
                        }
                        
                        lectures.append(Lecture(id: index+1, sigle: rawSigle, heading: "", content: content.joined(separator: "\n")))
                        
                    }
                    //if there is any text like
                    /*
                     Jeśli 25 grudnia, a tym samym 1 stycznia, przypada w niedzielę, wtedy święto zostaje przeniesione na 30 grudnia, przed Ewangelią jest tylko jedno czytanie.
                     Wersja dłuższa
                     */
                    else {
                        
                    }
                    
                } else {
                    print("SOmethign fdumb")
                }
                
            }
            catch {
                print(error)
            }
        }
        
        return .success(lectures)
    }
    
    
    func getDayOccasion() throws -> Result<String, Error> {
        guard let doc = try document?.select("#content > article > p.font-serif.fw-bold > em").first() else {
            //TODO: Handle that to be error prefferably
            return .success("Can not read 1")
        }
        
        
        return .success(try doc.text())
        
        
        
        //        TODO: Halso handle that, when it can not read that.
        //        return .success("Can not read 2")
    }
    
    
    func getVestmentColor() throws -> Result<VestmentColor, Error> {
        guard let doc = try document?.select("#content > article > p.font-sans > span").first() else {
            return .failure(ScrapingError.vestmentColorError)
        }
        
        switch(try doc.text()) {
        case "czerwony":
            return .success(.red)
        case "biały":
            return .success(.white)
        case "fioletowy":
            return .success(.purple)
        case "różowy":
            return .success(.pink)
        case "zielony":
            return .success(.green)
        case _:
            return .success(.other(try doc.text()))
        }
        
    }
    
    func fetchYear() -> String? {
        guard let doc = try? document?.select("#content > article > h1").first() else {
            return nil
        }
        
        let text = try? doc.text()
            .split(separator: ";")[1]
            .replacingOccurrences(of: "ROK", with: "")
            .trimmingCharacters(in: .whitespaces)
//            .split(separator: ",")[0]
//            .trimmingCharacters(in: .whitespaces)
        
        return text
    }
    
    
}
