//
//  SignupViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//


import SwiftUI


extension SignupView {
    @Observable
    class ViewModel {
        var isLoading = false
        var error = false
        
        
        @MainActor
        func signUp(username: String, password: String) async -> Bool {
            isLoading = true
            defer { isLoading = false }
            
            do {
                _ = try await API.signUp(body: LoginPayload(username: username, password: password))
                return true
            } catch {
                print(error.localizedDescription)
//                error = true
                return false
            }
        }
    }
}
