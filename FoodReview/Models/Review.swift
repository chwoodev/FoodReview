//
//  Review.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/27/26.
//

import SwiftUI


struct Review: Codable {
    let id: Int
    let userId: Int
    let menuId: Int
    let imageId: String
    let content: String?
    let taste: Int
    let amount: Int
    let price: Int
}
