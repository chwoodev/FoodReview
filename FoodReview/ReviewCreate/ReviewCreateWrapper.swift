//
//  CreateReviewView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/11/26.
//

import Foundation
import SwiftUI

struct ReviewCreateWrapper: View {
    var session: ReviewCreationSession
    @Environment(\.dismiss) private var dismiss
    let homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                if let image = session.cameraManager.capturedImage {
                    ScrollViewReader { proxy in
                        ScrollView{
                            ReviewCreateView(image: image, session: session, scrollProxy: proxy)
                            Color.clear
                                .frame(height: 1)
                                .id("bottomID")
                        }
                    }
                } else {
                    CameraView(cameraManager: session.cameraManager)
                }
            }
            .padding()
            .navigationTitle("리뷰 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark", role: .close) {
                        dismiss()
                    }
                }
                if session.cameraManager.capturedImage != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            session.reset()
                        }
                    }
                }
                if session.valid() {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Post", systemImage: "arrow.up", role: .confirm) {
                            let payload = session.toPayload()
                            dismiss()
                            session.reset()
                            Task {
                                guard let p  = payload else {return}
                                _ = try await API.uploadReview(body: p)
                                homeViewModel.requestFeedUpdate()
                            }
                        }
                    }
                }
            }
        }
    }
}
