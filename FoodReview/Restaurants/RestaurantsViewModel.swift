//
//  RestaurantsViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI

extension RestaurantsView {
    @Observable
    class ViewModel {
        var isLoading = true
        var error = false
        var restaurants: [Restaurant] = []
        
        
        @MainActor
        func fetchRestaurants() async {
            defer { isLoading = false }
            
            do {
                restaurants = try await API.getRestaurants().map {toRestaurant(r:$0)}
                self.error = false
            } catch {
                self.error = true
            }
        }
        
        @MainActor
        func deleteRestaurant(idx: IndexSet) async {
            let targets = idx.map { restaurants[$0] }
            restaurants.remove(atOffsets: idx)
            for r in targets {
                do {
                    try await API.deleteRestaurant(id: r.id)
                } catch {
                    await fetchRestaurants()
                }
            }
        }
    }
}
