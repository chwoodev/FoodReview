//
//  AddRestaurantView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/28/26.
//

import SwiftUI
import PhotosUI

struct AddRestaurantView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.accentColor.opacity(0.8))
                                    Text("로고 선택")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .onChange(of: selectedPhotoItem) { oldValue, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 16)
                }
                .listRowBackground(Color.clear)

                Section {
                    TextField("음식점 이름", text: $name)
                }
            }
            .navigationTitle("음식점 추가")
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
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || selectedPhotoItem == nil)
                    }
                }
            }
        }
    }
    
    private func saveRestaurant() async {
        guard let imageData = selectedImageData?.base64EncodedString() else { return }
        isLoading = true
        do {
            _ = try await API.createRestaurant(body: RestaurantCreatePayload(imageData: imageData, name: name))
        }catch {
            print(error.localizedDescription)
            isLoading = false
            return
        }
        dismiss()
    }
}
