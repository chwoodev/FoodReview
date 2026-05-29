//
//  Utils.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//

import SwiftUI

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

func convertRatingToGrade(_ rating: Float?) -> String {
    guard let rating = rating else { return "?" }
    let boundedRating = max(1.0, min(5.0, rating))
    let grades = [
        "F", "D-", "D0", "D+", "C-", "C0", "C+",
        "B-", "B0", "B+", "A-", "A0", "A+"
    ]
    var index = Int((13.0 * (boundedRating - 1.0)) / 4.0)
    if index >= grades.count {
        index = grades.count - 1
    }
    return grades[index]
}

func convertIntRatingToGrade(_ rating: Int) -> String {
    let boundedRating = max(1, min(5, rating))
    let grades = ["F", "D", "C", "B", "A"]
    return grades[boundedRating - 1]
}
