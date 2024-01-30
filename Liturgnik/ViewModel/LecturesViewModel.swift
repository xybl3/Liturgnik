//
//  LecturesViewModel.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import Foundation
import Combine

class LecturesViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isError = false
    @Published var selectedDate: Date = .now
    
    @Published var lectures: [Any] = []
    @Published var occasion: String? = nil
    @Published var vestmentColor: VestmentColor = .other("Brak danych")
    @Published var mszal: Mszal? = nil
    @Published var shouldAttend: Bool? = nil
        
    let scraper = NiedzielaScraper.shared
    private var cancellables = Set<AnyCancellable>()

    
    init(){
        print("🚀 [LecturesVM] Initialize VM")
        self.fetchLectures()
    }
    
    deinit{
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    func changeDate(to date: Date){
        self.selectedDate = date
        self.fetchLectures()
    }
    
    func fetchLectures(){
        performScrapeCombine()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let _):
                    self.isLoading = false
                    self.isError = true
                }
            } receiveValue: { (lectures: [Any], occasion: String, vestmentColor: VestmentColor, mszal: Mszal?, shouldAttend: Bool?) in
                self.lectures = lectures
                self.occasion = occasion
                self.vestmentColor = vestmentColor
                self.mszal = mszal
                self.shouldAttend = shouldAttend
            }
            .store(in: &cancellables)

    }
    
    
    private func performScrapeCombine() -> AnyPublisher < (lectures: [Any], occasion: String, vestmentColor: VestmentColor, mszal: Mszal?, shouldAttend: Bool?) , Error > {
        return Future { promise in
            self.scraper.setDate(to: self.selectedDate)
            
            Task {
                do {
                    try await self.scraper.performScrape()
                    
                    guard case let .success(lec) = self.scraper.getLectures() else {
                        print("Can not fetch lectures")
                        throw DayLoadingError.cannotFetchLectures
                    }
                    
                    guard case let .success(occ) = self.scraper.getDayOccasion() else {
                        print("Can not fetch occasion")
                        throw DayLoadingError.cannotFetchOccasion
                    }
                    
                    
                    guard case let .success(vestmentColor) = self.scraper.getVestmentColor() else {
                        print("Can not fetch vestment color")
                        throw DayLoadingError.cannotFetchVestment
                    }
                    
                    let mszal = ApiConnector.shared.getMszal()?.first(where: { m in
                                            if let dateFrom = DateUtils.dateFromString(from: m.dateFrom),
                                               let dateTo = DateUtils.dateFromString(from: m.dateTo) {
                                                return DateUtils.isWithinRange(targetDate: self.selectedDate, startDate: dateFrom, endDate: dateTo)
                                            }
                                            return false
                                        })

                    let shouldAttend = self.scraper.shouldAttend()
                    promise(.success((lec, occ, vestmentColor, mszal, shouldAttend)))
                  

                }
                catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
}
