//
//  RestaurantPickerViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

extension RestaurantPickerView {
    @Observable
    class ViewModel {
        var isLoading = true
        var error = false
        var restaurants: [PickerRestaurant] = []
        
        
        @MainActor
        func fetchRestaurants() async {
            isLoading = true
            defer { isLoading = false }
            
            do {
                restaurants = try await API.getPickerRestaurants()
            } catch {
                self.error = true
            }
        }
    }
}
