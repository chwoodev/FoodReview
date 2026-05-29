//
//  FeedView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//

import SwiftUI

struct FeedView: View {
    @State private var viewModel = ViewModel()
    @Environment(HomeViewModel.self) private var homeViewModel
    let updateRequest: Bool
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            }
            if viewModel.error {
                ContentUnavailableView("오류",
                                       systemImage: "wifi.exclamationmark")
            }
            if !viewModel.isLoading && !viewModel.error {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.reviews, id: \.self) { review in
                            let restaurant = viewModel.getRestaurant(menuId: review.menuId)
                            let menu = viewModel.getMenu(menuId: review.menuId)
                            FeedPostView(
                                review: review,
                                base64Icon: restaurant?.imageData,
                                restaurantName: restaurant?.name,
                                menuName: menu?.name
                            ) {
                                if homeViewModel.isLoggedIn {
                                    Task {
                                        await viewModel.toggleLike(review)
                                    }
                                }
                            }
                                .contextMenu {
                                    if review.userId == homeViewModel.userId || homeViewModel.isAdmin {
                                        Button(role: .destructive) {
                                            Task {
                                                await viewModel.deleteReview(id: review.id)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .overlay(alignment: .top) {
                    FeedGradientView()
                }
            }
        }
        .onChange(of: updateRequest) { _, _ in
            Task {
                await viewModel.fetchReviews()
            }
        }
        .task {
            await viewModel.fetchReviews()
        }
        .refreshable {
            await viewModel.fetchReviews()
        }
    }
}
