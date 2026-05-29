//
//  FeedPostView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//
import SwiftUI
import NukeUI

struct FeedPostView: View {
    let review: Review
    let restaurantIcon: UIImage?
    let restaurantName: String?
    let menuName: String?
    let onLike: () -> Void
    
    init(review: Review, imageData: Data?, restaurantName: String?, menuName: String?, onLike: @escaping () -> Void) {
        self.review = review
        self.onLike = onLike
        if let imageData = imageData {
            self.restaurantIcon = UIImage(data: imageData)
        } else {
            self.restaurantIcon = nil
        }
        self.restaurantName = restaurantName
        self.menuName = menuName
    }
    
    init(review: Review, base64Icon: String?, restaurantName: String?, menuName: String?, onLike: @escaping () -> Void) {
        self.review = review
        self.onLike = onLike
        if let base64Icon = base64Icon,
           let data = Data(base64Encoded: base64Icon) {
            self.restaurantIcon = UIImage(data: data)
        } else {
            self.restaurantIcon = nil
        }
        self.restaurantName = restaurantName
        self.menuName = menuName
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                HStack(spacing: 12){
                    RestaurantIconView(uiImage: restaurantIcon, size: 36)
                    Text(restaurantName ?? "???").font(.system(size: 18))
                }
                .foregroundStyle(Color(.label))
                Spacer()
                Text(menuName ?? "???").font(.system(size: 18, weight: .medium))
            }
            LazyImage(url: API.getImageURL(imageId: review.imageId)) { state in
                ZStack(alignment: .bottomLeading) {
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if state.error != nil {
                        Color.gray
                            .overlay(
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.white)
                            )
                    } else {
                        Color.gray
                    }
                    if review.likeCount > 0 || review.liked {
                        HStack(spacing: 4) {
                            Image(systemName: review.liked ? "heart.fill" : "heart")
                                .font(.system(size: 14, weight: .semibold))
                            Text("\(review.likeCount)")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.55), in: Capsule())
                        .padding(10)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    onLike()
                }
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            HStack{
                HStack{
                    Text("맛").foregroundStyle(Color(.secondaryLabel))
                    Text(convertIntRatingToGrade(review.taste)).font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
                HStack{
                    Text("양").foregroundStyle(Color(.secondaryLabel))
                    Text(convertIntRatingToGrade(review.amount)).font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
                HStack{
                    Text("가격").foregroundStyle(Color(.secondaryLabel))
                    Text(convertIntRatingToGrade(review.price)).font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
            }
            if let content = review.content {
                Text(content)
            }
        }
    }
}
