//
//  RestaurantsView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI

struct RestaurantsView: View {
    @State private var viewModel = ViewModel()
    @Environment(HomeViewModel.self) private var homeViewModel
    let isAdmin: Bool
    @State private var isPresentingAddSheet = false

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            }
            if viewModel.error {
                ContentUnavailableView("오류",
                                       systemImage: "wifi.exclamationmark")
            }
            List {
                ForEach(Array(viewModel.restaurants.enumerated()), id: \.element.id) { index, restaurant in
                    NavigationLink(destination: MenusView(restaurant: restaurant, isAdmin: isAdmin).environment(homeViewModel)) {
                        HStack(spacing: 16) {
                            RestaurantIconView(imageData: restaurant.imageData, size: 50)
                            Text(restaurant.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                VStack{
                                    Text(convertRatingToGrade(restaurant.taste))
                                        .font(.system(size: 20))
                                    Text("맛")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                                .padding(.horizontal, 3)
                                VStack{
                                    Text(convertRatingToGrade(restaurant.amount))
                                        .font(.system(size: 20))
                                    Text("양")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                                .padding(.horizontal, 3)
                                VStack{
                                    Text(convertRatingToGrade(restaurant.price))
                                        .font(.system(size: 20))
                                    Text("가격")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                                .padding(.horizontal, 3)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .deleteDisabled(!isAdmin)
                }
                .onDelete(perform: { idx in
                    Task {
                        await viewModel.deleteRestaurant(idx: idx)
                    }
                })
            }
            .navigationTitle("음식점")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isAdmin {
                        Button(action: { isPresentingAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddSheet, onDismiss: {
                Task {
                    await viewModel.fetchRestaurants()
                }
            }) {
                AddRestaurantView()
            }
            .task {
                await viewModel.fetchRestaurants()
            }
            
        }
    }

}
