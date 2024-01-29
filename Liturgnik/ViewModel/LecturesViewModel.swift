import SwiftUI
import Combine

class LecturesViewModel: ObservableObject {
    @Published var lectures: [Any] = []
    @Published var date: Date = .now
    @Published var occasion = ""
    @Published var vestmentColor: VestmentColor = .other("Brak danych")
    @Published var mszal: Mszal? = nil
    @Published var shouldAttend: Bool? = false
    
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    
    init() {
        fetchDay()
    }
    
    func fetchDay() {
        isLoading = true
        isError = false
        performScrapeCombine(date: date)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    self.isError = true
                case .finished:
                    self.isLoading = false
                }
            } receiveValue: { (lectures, occasion, vestmentColor, mszal, shouldAttend) in
                self.lectures = lectures
                self.occasion = occasion
                self.vestmentColor = vestmentColor
                self.mszal = mszal
                self.shouldAttend = shouldAttend
            }
            .store(in: &cancellables)
    }
    
    func setDate(to d: Date) {
        date = d
        fetchDay()
    }
    
    deinit {
        cancellables.forEach { canc in
            canc.cancel()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func performScrapeCombine(date: Date) -> AnyPublisher<(lectures: [Any], occasion: String, vestmentColor: VestmentColor, mszal: Mszal?, shouldAttend: Bool?), Error> {
        return Future { promise in
            NiedzielaScraper.shared.setDate(to: date)
            
            Task {
                do {
                    try await NiedzielaScraper.shared.performScrape()
                    let lectures = try NiedzielaScraper.shared.getLectures().get()
                    let occasion = try NiedzielaScraper.shared.getDayOccasion().get()
                    let vestmentColor = try NiedzielaScraper.shared.getVestmentColor().get()
                    let mszal = ApiConnector.shared.getMszal()?.first(where: { m in
                        if let dateFrom = DateUtils.dateFromString(from: m.dateFrom),
                           let dateTo = DateUtils.dateFromString(from: m.dateTo) {
                            return DateUtils.isWithinRange(targetDate: date, startDate: dateFrom, endDate: dateTo)
                        }
                        return false
                    })
                    let shouldAttend = NiedzielaScraper.shared.shouldAttend()
                    promise(.success((lectures: lectures, occasion: occasion, vestmentColor: vestmentColor, mszal: mszal, shouldAttend: shouldAttend)))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
