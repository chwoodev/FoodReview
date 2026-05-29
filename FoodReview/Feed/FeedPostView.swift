//
//  FeedPostView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//
import SwiftUI

struct FeedPostView: View {
    let post: FeedPost
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                HStack{
                    Image(systemName: "fork.knife").font(.system(size: 22))
                    Text("AB 식당").font(.system(size: 18))
                }
                .foregroundStyle(Color(hex: 0x242424))
                Spacer()
                Text(post.text).font(.system(size: 18, weight: .medium))
            }
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 300)
                .cornerRadius(10)
            HStack{
                HStack{
                    Text("맛").foregroundStyle(Color(hex: 0x4d4d4d))
                    Text("A-").font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
                HStack{
                    Text("양").foregroundStyle(Color(hex: 0x4d4d4d))
                    Text("A+").font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
                HStack{
                    Text("가격").foregroundStyle(Color(hex: 0x4d4d4d))
                    Text("B0").font(.system(size: 22, weight: .light))
                }
                .frame(maxWidth: .infinity)
            }
            Text("This is a caption for the post.")
            HStack{
                Image(systemName: "heart.fill")
                    .foregroundStyle(Color.red)
                Text("\(post.likes) Likes")
                    .foregroundStyle(Color.red)
            }
        }
    }
}

#Preview {
    FeedPostView(post: FeedPost(text: "asdf", likes: 13))
}
