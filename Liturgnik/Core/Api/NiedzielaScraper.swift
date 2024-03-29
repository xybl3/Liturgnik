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
    case cannotGetDayOccasion
    case vestmentColorError
    case sigleNotFound
    case scrapeError
}


/// Aby móc scrapować, trzeba użyć singletona ``NiedzielaScraper`` uzywajac
///
/// > Warning:  Ważne aby przed wykonaniem jakiejkolwek opecacji, wykonać metodę ``performScrape()``
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
                    
                    if sigle.starts(with: "Wersja") {
                        
                        let category = try lecture.children()[1].text()
                        
                        if category.starts(with: "Ewangelia") {
                            
                            let content =  String(lecture.children().map({
                                do {
                                    return try $0.text()
                                }
                                catch {
                                    return "Nie mozna odczytac zawartości"
                                }
                            }).joined(separator: "\n"))
                            
                            
                            /// Kiedy jest wiecej niż jedna wersja ewangelii
                            let sigleInExceptionLecture = "Ewangelia \(try lecture.select("h2").map({try $0.text()}).joined(separator: " lub ").replacingOccurrences(of: "Ewangelia", with: ""))"
                            
                            lectures.append(Lecture(id: index+1, sigle: sigleInExceptionLecture, heading: "", content: content))
                        }
                    }
                    
                   
                    
                    // To jest czytanie
                    if sigle.range(of: "^\\d\\.", options: .regularExpression) != nil {
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
                    else if sigle.range(of: "Psalm", options: .regularExpression) != nil {
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
                    
                    else if sigle.range(of: "Aklamacja", options: .regularExpression) != nil {
                        
                        let chorus = try lecture.select("#tabnowy0\(index) > h4").text()
                        
                        var verses: [String] = []
                        
                        for v in try lecture.select("#tabnowy0\(index) > p:nth-child(4)") {
                            verses.append(try v.text())
                        }
                        
                        lectures.append(Acclamation(id: index+1, chorus: chorus, verses: verses))
                    }
                    else if sigle.range(of: "Ewangelia", options: .regularExpression) != nil{
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
                    // Miało byc użyte ale jednak nie było
//                    // kiedy jest
//                    /*
//                     Jeśli 25 grudnia, a tym samym 1 stycznia, przypada w niedzielę, wtedy święto zostaje przeniesione na 30 grudnia, przed Ewangelią jest tylko jedno czytanie.
//                     Wersja dłuższa
//                     */
//                    else {
//                        
//                    }
                    
                }
            }
            catch {
                print(error)
            }
        }
        
        return .success(lectures)
    }
    
    
    func getDayOccasion() -> Result<String, Error> {
        do {
            guard let doc = try document?.select("#content > article > p.font-serif.fw-bold > em").first() else {
                return .failure(ScrapingError.cannotGetDayOccasion)
            }
            return .success(try doc.text())
        } catch {
            return .failure(ScrapingError.cannotGetDayOccasion)
        }
    }
    
    func getVestmentColor() -> Result<VestmentColor, Error> {
        do {
            guard let doc = try document?.select("#content > article > p.font-sans > span").first() else {
                return .failure(ScrapingError.vestmentColorError)
            }
            return .success(VestmentColor.fromString(inputStr: try doc.text()))
        }
        catch {
            return .failure(ScrapingError.vestmentColorError)
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
        
        return text
    }
    
    
    func shouldAttend() -> Bool? {
        guard let doc = try? document?.select("#dzien > div > div > div.col-md-9 > div > div.col-12.col-lg-7 > div > p > em") else { return nil }

        let text = try? doc.text()
        
        return text == "Weź udział we Mszy św."
    }
}


class NiedzielaScraper2 {
    
    static let shared = NiedzielaScraper2()
    
    private init(){
        print("Initizlize NiedzielaScraper")
    }
    
    
    private var date: Date = .now
    private var document: Document?
    private var url = URL(string: "https://widget.niedziela.pl/liturgia_out.js.php?")!
    
    func setDate(to date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: date ?? Date())
        
        self.url = URL(string: "https://widget.niedziela.pl/liturgia_out.js.php?data=\(formattedDate)")!
    }
    
    func performScrape() async -> Void {
        do {
            let (data, response) = try await URLSession.shared.data(from: self.url)
            
            
            var htmlString = String(data: data, encoding: .utf8)
//            print(htmlString)
            
            let replaceJSString = "\'); setTimeout"
            
            let replaceDocumentWriteJS = "document.write('"

        
            
            guard htmlString != nil else {
                print("Scraping error")
                throw ScrapingError.scrapeError
            }
            
            self.document = try SwiftSoup.parse(htmlString ?? "")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getDayOccasion() throws -> String? {
        
        guard self.document != nil else {
            throw ScrapingError.cannotGetDayOccasion
        }
        
        
        return String(try self.document?.select(".nd_dzien").first()?.text().components(separatedBy: ", ")[1] ?? "")
    }
    
}
