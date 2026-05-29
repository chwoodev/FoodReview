//
//  MenusView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct MenusView: View {
    @State private var viewModel = ViewModel()
    @State private var isPresentingAddSheet = false
    let restaurant: Restaurant
    let isAdmin: Bool
    
    var body: some View {
        List {
            ForEach(Array(viewModel.menus.enumerated()), id: \.element.id) { index, menu in
                NavigationLink(destination: MenuFeedView(menu: menu)) {
                    HStack(spacing: 16) {
                        Text(menu.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            HStack{
                                Text("맛")
                                    .font(.subheadline)
                                Text(convertRatingToGrade(menu.taste))
                                    .font(.system(size: 24))
                            }
                            .frame(minWidth: 36)
                            HStack{
                                Text("양")
                                    .font(.subheadline)
                                Text(convertRatingToGrade(menu.amount))
                                    .font(.system(size: 24))
                            }
                            .frame(minWidth: 36)
                            HStack{
                                Text("가격")
                                    .font(.subheadline)
                                Text(convertRatingToGrade(menu.price))
                                    .font(.system(size: 24))
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
//                    await viewModel.deleteRestaurant(idx: idx)
                }
            })
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
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
                await viewModel.fetchMenus(id: restaurant.id)
            }
        }) {
            AddMenuView(restaurantId: restaurant.id)
        }
        .task {
            await viewModel.fetchMenus(id: restaurant.id)
        }
    }
}
