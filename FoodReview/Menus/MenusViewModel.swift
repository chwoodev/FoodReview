//
//  MenusViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

extension MenusView {
    @Observable
    class ViewModel {
        var isLoading = true
        var error = false
        var menus: [FoodMenu] = []
        
        
        @MainActor
        func fetchMenus(id: Int) async {
            isLoading = true
            defer { isLoading = false }
            
            do {
                menus = try await API.getMenus(id: id).map {toFoodMenu(r:$0)}
            } catch {
                self.error = true
            }
        }
        
//        @MainActor
//        func deleteRestaurant(idx: IndexSet) async {
//            let targets = idx.map { restaurants[$0] }
//            restaurants.remove(atOffsets: idx)
//            for r in targets {
//                do {
//                    try await API.deleteRestaurant(id: r.id)
//                } catch {
//                    await fetchRestaurants()
//                }
//            }
//        }
    }
}
