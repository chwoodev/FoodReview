//
//  FoodMenu.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct FoodMenu: Identifiable {
    let id: Int
    var name: String
    var restaurantId: Int
    var taste: Float?
    var amount: Float?
    var price: Float?
}


struct RawFoodMenu: Decodable {
    let id: Int
    var name: String
    var restaurantId: Int
    var sumTaste: Int
    var sumAmount: Int
    var sumPrice: Int
    var reviewCount: Int
}

struct PickerFoodMenu: Decodable, Identifiable {
    let id: Int
    let name: String
}

func toFoodMenu(r: RawFoodMenu) -> FoodMenu {
    if(r.reviewCount == 0){
        return FoodMenu(id: r.id, name: r.name, restaurantId: r.restaurantId)
    }
    let c = Float(r.reviewCount)
    let taste = Float(r.sumTaste) / c
    let amount = Float(r.sumAmount) / c
    let price = Float(r.sumPrice) / c
    return FoodMenu(id: r.id, name: r.name, restaurantId: r.restaurantId, taste: taste, amount: amount, price: price)
}
