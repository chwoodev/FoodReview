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
    @Environment(HomeViewModel.self) private var homeViewModel
    
    let restaurant: Restaurant
    let isAdmin: Bool
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        }
        if viewModel.error {
            ContentUnavailableView("오류",
                                   systemImage: "wifi.exclamationmark")
        }
        List {
            ForEach(Array(viewModel.menus.enumerated()), id: \.element.id) { index, menu in
                NavigationLink(destination: MenuFeedView(menu: menu, restaurant: restaurant).environment(homeViewModel)) {
                    HStack(spacing: 16) {
                        Text(menu.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            VStack{
                                Text(convertRatingToGrade(menu.taste))
                                    .font(.system(size: 20))
                                Text("맛")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 3)
                            .frame(minWidth: 36)
                            VStack{
                                Text(convertRatingToGrade(menu.amount))
                                    .font(.system(size: 20))
                                Text("양")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 3)
                            .frame(minWidth: 36)
                            VStack{
                                Text(convertRatingToGrade(menu.price))
                                    .font(.system(size: 20))
                                Text("가격")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 3)
                            .frame(minWidth: 36)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .deleteDisabled(!isAdmin)
            }
            .onDelete(perform: { idx in
                Task {
                    let result = await viewModel.deleteMenu(idx: idx)
                    if !result {
                        await viewModel.fetchMenus(id: restaurant.id)
                    }
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
