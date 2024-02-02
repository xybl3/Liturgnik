//
//  DayLoadingError.swift
//  Liturgnik
//
//  Created by Olivier Marszałkowski on 30/01/2024.
//

import Foundation


enum DayLoadingError: Error {
    case cannotFetchLectures
    case cannotFetchOccasion
    case cannotFetchVestment
}
