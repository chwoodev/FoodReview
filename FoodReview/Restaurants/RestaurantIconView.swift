//
//  RestaurantIconView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct RestaurantIconView: View {
    let uiImage: UIImage?
    let size: CGFloat

    init(base64String: String?, size: CGFloat) {
        self.size = size
        if let base64String = base64String,
           let data = Data(base64Encoded: base64String) {
            self.uiImage = UIImage(data: data)
        } else {
            self.uiImage = nil
        }
    }

    init(imageData: Data?, size: CGFloat) {
        self.size = size
        if let imageData = imageData {
            self.uiImage = UIImage(data: imageData)
        } else {
            self.uiImage = nil
        }
    }
    
    init(uiImage: UIImage?, size: CGFloat) {
        self.size = size
        self.uiImage = uiImage
    }

    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color.secondary.opacity(0.2))
                .frame(width: size, height: size)
                .overlay {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.secondary)
                }
        }
    }
}
