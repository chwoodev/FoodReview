//
//  LoginViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI


extension LoginView {
    @Observable
    class ViewModel {
        var isLoading = false
        var error = false
        
        
        @MainActor
        func logIn(username: String, password: String) async -> Bool {
            isLoading = true
            defer { isLoading = false }
            
            do {
                _ = try await API.logIn(body: LoginPayload(username: username, password: password))
                return true
            } catch {
                print(error.localizedDescription)
//                error = true
                return false
            }
        }
    }
}
