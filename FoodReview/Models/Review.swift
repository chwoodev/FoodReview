//
//  Review.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/27/26.
//

import SwiftUI


struct Review: Codable, Hashable {
    let id: Int
    let userId: Int
    let menuId: Int
    let imageId: String
    let content: String?
    let taste: Int
    let amount: Int
    let price: Int
    let likeCount: Int
    let liked: Bool
}

extension Review {
    func toggledLike() -> Review {
        Review(
            id: id,
            userId: userId,
            menuId: menuId,
            imageId: imageId,
            content: content,
            taste: taste,
            amount: amount,
            price: price,
            likeCount: liked ? max(0, likeCount - 1) : likeCount + 1,
            liked: !liked
        )
    }
}
