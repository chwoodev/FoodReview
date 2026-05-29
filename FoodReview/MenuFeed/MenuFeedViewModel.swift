//
//  MenuFeedViewModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

extension MenuFeedView{
    @Observable
    class ViewModel{
        var isLoading = true
        var error = false
        var reviews: [Review] = []
        
        
        @MainActor
        func fetchReviews(id: Int) async {
            defer { isLoading = false }
            
            do {
                reviews = try await API.getReviewsForMenu(id: id)
            } catch {
                self.error = true
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
    }
}
