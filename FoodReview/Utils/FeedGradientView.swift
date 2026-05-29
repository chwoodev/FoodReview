//
//  FeedGradientView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/29/26.
//

import SwiftUI

struct FeedGradientView: View {
    var body: some View {
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
