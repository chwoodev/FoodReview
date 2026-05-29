//
//  DTO.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/21/26.
//
import SwiftUI

struct ReviewPayload: Encodable {
    let menuId: Int
    let content: String
    let taste: Int
    let amount: Int
    let price: Int
    let imageData: String
}

struct LoginPayload: Encodable {
    let username: String
    let password: String
}

struct RestaurantCreatePayload: Encodable {
    let imageData: String
    let name: String
}

struct MenuCreatePayload: Encodable {
    let name: String
}
