//
//  MenuFeedView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct MenuFeedView: View {
    @State private var viewModel = ViewModel()
    @Environment(HomeViewModel.self) private var homeViewModel
    let menu: FoodMenu
    let restaurant: Restaurant
    
    
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
                            FeedPostView(
                                review: review,
                                imageData: restaurant.imageData,
                                restaurantName: restaurant.name,
                                menuName: menu.name
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
        .navigationTitle(menu.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchReviews(id: menu.id)
        }
        .refreshable {
            await viewModel.fetchReviews(id: menu.id)
        }
    }
}
