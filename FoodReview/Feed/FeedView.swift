//
//  FeedView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/15/26.
//

import SwiftUI

struct FeedView: View {
    //나중에 viewmodel으로
    let posts: [FeedPost] = Array(1...50).map { FeedPost(text: "this is a sample \($0)", likes: Int(pow(Double($0), 2))) }
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(posts, id: \.self) { post in
                    FeedPostView(post: post)
                }
            }
            .padding()
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 70)
                .mask {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(hex: 0x000000, opacity: 0.85), location: 0.5),
                            Gradient.Stop(color: .clear, location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea(edges: .top)
        }
    }
}
