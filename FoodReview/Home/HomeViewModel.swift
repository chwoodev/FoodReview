//
//  HomeViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/27/26.
//

import SwiftUI

extension HomeView{
    @Observable
    class ViewModel {
        var isLoggedIn = false
        var isLoading = true
        var isAdmin = false
        
        @MainActor
        func checkLoginState() async {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let profile = try await API.getProfile()
                isLoggedIn = true
                isAdmin = profile.isAdmin
            } catch {
                isLoggedIn = false
            }
        }
    }
}
