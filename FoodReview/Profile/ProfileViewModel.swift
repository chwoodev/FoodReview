//
//  ProfileViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

extension ProfileView {
    @Observable
    class ViewModel {
        let homeViewModel: HomeViewModel
        var isLoading = true
        var isLoggingOut = false
        var error = false
        var profile: Profile? = nil
        var reviews: [Review] = []
        var restaurants: [PickerRestaurant] = []
        
        init(homeViewModel: HomeViewModel) {
            self.homeViewModel = homeViewModel
        }
        
        
        @MainActor
        func fetchReviews() async {
            defer { isLoading = false }
            
            do {
                profile = try await API.getProfile()
                restaurants = try await API.getPickerRestaurants()
                reviews = try await API.getMyReviews()
                self.error = false
            } catch {
                print(error.localizedDescription)
                self.error = true
            }
        }
        
        func getRestaurant(menuId: Int) -> PickerRestaurant? {
            return restaurants.first { r in
                r.menus.contains { menu in
                    menu.id == menuId
                }
            }
        }
        
        func getMenu(menuId: Int) -> PickerFoodMenu? {
            return restaurants.flatMap { r in
                r.menus
            }.first { menu in
                menu.id == menuId
            }
        }
        
        @MainActor
        func deleteReview(id: Int) async {
            do {
                _ = try await API.deleteReview(id: id)
                reviews.removeAll { review in
                    review.id == id
                }
            } catch {
            }
        }
        
        @MainActor
        func toggleLike(_ review: Review) async {
            guard let reviewIndex = reviews.firstIndex(where: { $0.id == review.id }) else {
                return
            }
            
            let originalReview = reviews[reviewIndex]
            reviews[reviewIndex] = originalReview.toggledLike()
            
            do {
                if originalReview.liked {
                    _ = try await API.unlikeReview(id: originalReview.id)
                } else {
                    _ = try await API.likeReview(id: originalReview.id)
                }
                
            } catch {
            }
        }
        
        @MainActor
        func logOut() async -> Bool {
            isLoggingOut = true
            defer { isLoggingOut = false }
            
            do {
                try await API.logOut()
                await homeViewModel.checkLoginState()
            } catch {
                return false
            }
            return true
        }
    }
}
