//
//  HomeViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/27/26.
//

import SwiftUI
import Observation

@Observable
class HomeViewModel {
    var isLoggedIn = false
    var isLoading = true
    var isAdmin = false
    var userId: Int?
    var updateFeed = false
    
    @MainActor
    func checkLoginState() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let profile = try await API.getProfile()
            isLoggedIn = true
            isAdmin = profile.isAdmin
            userId = profile.id
        } catch {
            isLoggedIn = false
            isAdmin = false
            userId = nil
        }
    }
    
    func requestFeedUpdate() {
        updateFeed = true
    }
}

