//
//  API.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/21/26.
//
import Foundation
import Alamofire

let base = "https://woo.api.newbie.sparcs.net"

class API {
    private static func fetch<T: Decodable, P: Encodable>(
        _ url: String,
        method: HTTPMethod = .get,
        body: P? = nil,
        as type: T.Type
    ) async throws -> T{
        let req = AF.request(url, method: method, parameters: body, encoder: JSONParameterEncoder.default)
        return try await req.serializingDecodable(T.self).value
    }

    static func fetch<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        as type: T.Type
    ) async throws -> T{
        let req = AF.request(url, method: method)
        return try await req.serializingDecodable(T.self).value
    }
    
    static func getImageURL(imageId: String) -> URL? {
        return URL(string: "\(base)/images/\(imageId)")
    }
    
    static func uploadReview(body: ReviewPayload) async throws -> Review {
        return try await fetch("\(base)/reviews/upload", method: .post, body: body, as: Review.self)
    }
    
    static func getProfile() async throws -> Profile {
        return try await fetch("\(base)/users/profile", as: Profile.self)
    }
    
    static func logIn(body: LoginPayload) async throws -> Profile {
        return try await fetch("\(base)/auth/login", method: .post, body: body, as: Profile.self)
    }
    
    static func logOut() async throws {
        _ = try await fetch("\(base)/auth/logout", method: .post, as: Empty.self)
    }
    
    static func signUp(body: LoginPayload) async throws -> Profile {
        return try await fetch("\(base)/auth/signup", method: .post, body: body, as: Profile.self)
    }
    
    static func getRestaurants() async throws -> [RawRestaurant] {
        return try await fetch("\(base)/restaurants", as: [RawRestaurant].self)
    }
    
    static func getPickerRestaurants() async throws -> [PickerRestaurant] {
        return try await fetch("\(base)/restaurants/menus", as: [PickerRestaurant].self)
    }
    
    static func createRestaurant(body: RestaurantCreatePayload) async throws -> RawRestaurant {
        return try await fetch("\(base)/restaurants/create", method: .post, body: body, as: RawRestaurant.self)
    }
    
    static func deleteRestaurant(id: Int) async throws {
        _ = try await fetch("\(base)/restaurants/\(id)", method: .delete,  as: Empty.self)
    }
    
    static func getMenus(id: Int) async throws -> [RawFoodMenu] {
        return try await fetch("\(base)/menus/restaurant/\(id)", as: [RawFoodMenu].self)
    }
    
    static func createMenu(id: Int, body: MenuCreatePayload) async throws -> RawFoodMenu {
        return try await fetch("\(base)/menus/restaurant/\(id)/create", method: .post, body: body, as: RawFoodMenu.self)
    }
    
    static func deleteMenu(id: Int) async throws {
        _ = try await fetch("\(base)/menus/\(id)", method: .delete, as: Empty.self)
    }

    static func getReviews() async throws -> [Review] {
        return try await fetch("\(base)/reviews", as: [Review].self)
    }
    
    static func getMyReviews() async throws -> [Review] {
        return try await fetch("\(base)/reviews/my", as: [Review].self)
    }
    
    static func getReviewsForMenu(id: Int) async throws -> [Review] {
        return try await fetch("\(base)/reviews/menu/\(id)", as: [Review].self)
    }
    
    static func deleteReview(id: Int) async throws {
        _ = try await fetch("\(base)/reviews/\(id)", method: .delete, as: Empty.self)
    }
    
    static func likeReview(id: Int) async throws -> [Review] {
        return try await fetch("\(base)/reviews/\(id)/like", method: .post, as: [Review].self)
    }
    
    static func unlikeReview(id: Int) async throws -> [Review] {
        return try await fetch("\(base)/reviews/\(id)/like", method: .delete, as: [Review].self)
    }

}
