//
//  ProfileView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ViewModel
    init(homeViewModel: HomeViewModel) {
        _viewModel = State(wrappedValue: ViewModel(homeViewModel: homeViewModel))
    }
    @Environment(\.dismiss) private var dismiss
    
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
                                if viewModel.homeViewModel.isLoggedIn {
                                    Task {
                                        await viewModel.toggleLike(review)
                                    }
                                }
                            }
                                .contextMenu {
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
                    .padding()
                }
                .overlay(alignment: .top) {
                    FeedGradientView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isLoggingOut {
                    ProgressView()
                } else {
                    Button("Logout", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                        Task {
                            let result = await viewModel.logOut()
                            if result {
                                dismiss()
                            }
                        }
                    }
                    .tint(.red)
                }
            }
        }
        .navigationTitle(viewModel.profile?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchReviews()
        }
        .refreshable {
            let refreshTask = Task {
                await viewModel.fetchReviews()
            }
            await refreshTask.value
        }
    }
    
}
