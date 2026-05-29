//
//  RestaurantPickerView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/21/26.
//

import SwiftUI

struct RestaurantPickerView: View {
    @State private var viewModel = ViewModel()
    
    @Binding var selectedMenu: PickerFoodMenu?
    @Binding var selectedRestaurant: PickerRestaurant?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.restaurants) { group in
                    Section(header:
                        HStack{
                        if let data = Data(base64Encoded: group.imageData), let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                    .overlay {
                                        Image(systemName: "fork.knife")
                                            .foregroundColor(.secondary)
                                    }
                            }
                            Text(group.name).font(.system(size: 18))
                        }
                        .foregroundStyle(Color(.label))
                    ) {
                        RestaurantMenuListView(group: group, selectedMenu: $selectedMenu, selectedRestaurant: $selectedRestaurant)
                    }
                }
            }
            .navigationTitle("메뉴 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", role: .close) {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchRestaurants()
        }
    }
}

struct RestaurantMenuListView: View {
    let group: PickerRestaurant
    @Binding var selectedMenu: PickerFoodMenu?
    @Binding var selectedRestaurant: PickerRestaurant?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ForEach(group.menus) { menu in
            Button(action: {
                selectedMenu = menu
                selectedRestaurant = group
                dismiss()
            }) {
                HStack{
                    Text(menu.name)
                        .foregroundStyle(Color(.label))
                    Spacer()
                    if selectedMenu?.id == menu.id {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}
