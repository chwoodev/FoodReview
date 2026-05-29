//
//  Untitled.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/21/26.
//
import SwiftUI

struct Restaurant: Identifiable {
    let id: Int
    var name: String
    var imageData: Data?
    var taste: Float?
    var amount: Float?
    var price: Float?
}


struct RawRestaurant: Decodable {
    let id: Int
    var name: String
    var imageData: String
    var sumTaste: Int
    var sumAmount: Int
    var sumPrice: Int
    var reviewCount: Int
}

struct PickerRestaurant: Decodable, Identifiable {
    let id: Int
    let name: String
    let imageData: String
    let menus: [PickerFoodMenu]
}

func toRestaurant(r: RawRestaurant) -> Restaurant {
    if(r.reviewCount == 0){
        return Restaurant(id: r.id, name: r.name, imageData: Data(base64Encoded: r.imageData))
    }
    let c = Float(r.reviewCount)
    let taste = Float(r.sumTaste) / c
    let amount = Float(r.sumAmount) / c
    let price = Float(r.sumPrice) / c
    return Restaurant(id: r.id, name: r.name, imageData: Data(base64Encoded: r.imageData), taste: taste, amount: amount, price: price)
}
