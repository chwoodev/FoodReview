//
//  AddMenuView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//


import SwiftUI

struct AddMenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    let restaurantId: Int
    @State private var name: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("메뉴 이름", text: $name)
                }
            }
            .navigationTitle("메뉴 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Add", systemImage: "checkmark", role: .confirm) {
                            Task {
                                await saveRestaurant()
                            }
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
    
    private func saveRestaurant() async {
        isLoading = true
        do {
            _ = try await API.createMenu(id: restaurantId, body: MenuCreatePayload(name: name))
        }catch {
            print(error.localizedDescription)
            isLoading = false
            return
        }
        dismiss()
    }
}
