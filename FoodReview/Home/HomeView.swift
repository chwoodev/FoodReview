//
//  ContentView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/9/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var isReviewScreenPresented = false
    @State private var isLoginPresented = false
    @State private var isRestaurantsPresented = false
    @State private var isProfilePresented = false
    @State private var reviewCreationSession = ReviewCreationSession()
    
    
    var body: some View {
        NavigationStack{
            VStack {
                FeedView(updateRequest: viewModel.updateFeed)
                    .environment(viewModel)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Restaurants", systemImage: "list.bullet") {
                        isRestaurantsPresented = true
                    }
                    .navigationDestination(isPresented: $isRestaurantsPresented) {
                        RestaurantsView(isAdmin: viewModel.isAdmin)
                            .environment(viewModel)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        if viewModel.isLoggedIn {
                            Button("Profile", systemImage: "person.fill") {
                                isProfilePresented = true
                            }
                            .tint(viewModel.isAdmin ? Color.accentColor : nil)
                            .navigationDestination(isPresented: $isProfilePresented) {
                                ProfileView(homeViewModel: viewModel)
                                    .environment(viewModel)
                            }
                        } else {
                            Button("Profile", systemImage: "person.slash.fill") {
                                isLoginPresented = true
                            }
                            .sheet(isPresented: $isLoginPresented, onDismiss: {
                                Task {
                                    await viewModel.checkLoginState()
                                }
                            }) {
                                LoginView()
                                    .presentationBackground(Color(.secondarySystemBackground))
                                    .presentationDragIndicator(.visible)
                            }
                        }
                    }
                    
                }
                
                if viewModel.isLoggedIn {
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        Button("Post", systemImage: "plus", role: .confirm) {
                            isReviewScreenPresented = true
                        }
                        .sheet(isPresented: $isReviewScreenPresented) {
                            ReviewCreateWrapper(session: reviewCreationSession, homeViewModel: viewModel)
                                .presentationBackground(Color(.secondarySystemBackground))
                                .presentationDetents([.large])
                        }
                    }
                }
                
            }
        }
        .task {
            await viewModel.checkLoginState()
        }
    }
}

#Preview {
    HomeView()
}
