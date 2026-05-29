//
//  API.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/21/26.
//
import Foundation
import Alamofire

//let base = "https://woo.api.newbie.sparcs.me"
let base = "http://192.168.0.8:3000"

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
    
    static func uploadReview(body: ReviewPayload) async throws -> Review {
        return try await fetch("\(base)/reviews/upload", method: .post, body: body, as: Review.self)
    }
    
    static func getProfile() async throws -> Profile {
        return try await fetch("\(base)/users/profile", as: Profile.self)
    }
    
    static func logIn(body: LoginPayload) async throws -> Profile {
        return try await fetch("\(base)/auth/login", method: .post, body: body, as: Profile.self)
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

//    static func getSemesters() async throws -> [Semester] {
//        return try await fetch("\(base)/api/semesters", as: [Semester].self).sorted {$0.order > $1.order}
//    }
//
//    static func getStudents(subject id: Int) async throws -> [Student] {
//        return try await fetch("\(base)/api/subjects/\(id)/students", as: [Student].self)
//    }
//
//    static func addStudent(subject id: Int, body: StudentPayload) async throws -> Student{
//        return try await fetch("\(base)/api/subjects/\(id)/students", method: .post, body: body, as: Student.self)
//    }
//    
//    static func editStudent(student id: Int, body: StudentPayload) async throws -> Student{
//        return try await fetch("\(base)/api/students/\(id)", method: .patch, body: body, as: Student.self)
//    }
//    
//    static func removeStudent(student id: Int) async throws{
//         _ = try await fetch("\(base)/api/students/\(id)", method: .delete, as: Empty.self)
//    }

}
