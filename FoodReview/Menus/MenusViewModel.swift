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
            defer { isLoading = false }
            
            do {
                menus = try await API.getMenus(id: id).map {toFoodMenu(r:$0)}
                self.error = false
            } catch {
                self.error = true
            }
        }
        
        @MainActor
        func deleteMenu(idx: IndexSet) async -> Bool{
            let targets = idx.map { menus[$0] }
            menus.remove(atOffsets: idx)
            for m in targets {
                do {
                    try await API.deleteMenu(id: m.id)
                } catch {
                    return false
                }
            }
            return true
        }
    }
}
