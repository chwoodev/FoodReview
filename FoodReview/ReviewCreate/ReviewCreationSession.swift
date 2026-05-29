//
//  ReviewCreationSession.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//

import SwiftUI

@Observable
class ReviewCreationSession {
    var reviewText: String = ""
    var cameraManager = CameraManager()
    
    var tasteRating: Int = 0
    var amountRating: Int = 0
    var priceRating: Int = 0
    var selectedMenu: PickerFoodMenu? = nil
    var selectedRestaurant: PickerRestaurant? = nil
    
    func reset() {
        reviewText = ""
        tasteRating = 0
        amountRating = 0
        priceRating = 0
        selectedMenu = nil
        selectedRestaurant = nil
        cameraManager.reset()
    }
    
    func valid() -> Bool {
        return cameraManager.capturedImage != nil &&
            tasteRating >= 1 &&
            amountRating >= 1 &&
            priceRating >= 1 &&
            selectedMenu != nil
    }
    
    func toPayload() -> ReviewPayload? {
        guard let menuId = selectedMenu?.id else { return nil }
//        let imageData = cameraManager.capturedImage?.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        let imageData = UIImage(systemName: "house")?.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        guard let base64 = imageData else { return nil }
        return ReviewPayload(menuId: menuId, content: reviewText, taste: tasteRating, amount: amountRating, price: priceRating, imageData: base64)
    }
}
 
