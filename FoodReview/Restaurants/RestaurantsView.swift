//
//  RestaurantsView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI

struct RestaurantsView: View {
    @State private var viewModel = ViewModel()
    let isAdmin: Bool
    @State private var isPresentingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.restaurants.enumerated()), id: \.element.id) { index, restaurant in
                    NavigationLink(destination: MenusView(restaurant: restaurant, isAdmin: isAdmin)) {
                        HStack(spacing: 16) {
                            if let data = restaurant.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image(systemName: "fork.knife")
                                            .foregroundColor(.secondary)
                                    }
                            }
                            
                            Text(restaurant.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                VStack{
                                    Text(convertRatingToGrade(restaurant.taste))
                                        .font(.system(size: 24))
                                    Text("맛")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                                VStack{
                                    Text(convertRatingToGrade(restaurant.amount))
                                        .font(.system(size: 24))
                                    Text("양")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                                VStack{
                                    Text(convertRatingToGrade(restaurant.price))
                                        .font(.system(size: 24))
                                    Text("가격")
                                        .font(.subheadline)
                                }
                                .frame(minWidth: 36)
                            }
                        }
                        .padding(.vertical, 4)
                        .deleteDisabled(!isAdmin)
                    }
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
