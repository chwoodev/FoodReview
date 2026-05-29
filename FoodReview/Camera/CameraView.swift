//
//  CameraView.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/9/26.
//
import SwiftUI
import AVFoundation
import AVKit

struct CameraView: View {
    let cameraManager: CameraManager
    @State var isTakingPhoto = false
    
    var body: some View {
        Spacer()
        CameraViewfinder(cameraManager: cameraManager)
        Spacer()
        Button(action: {
            if isTakingPhoto { return }
            isTakingPhoto = true
//            cameraManager.takePhoto()
            cameraManager.capturedImage = UIImage(systemName: "house")
        }){
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 70, height: 70)
                .glassEffect()
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .glassEffect()
                        .padding(5)
                )
        }
        
    }
}

struct CameraViewfinder: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        ZStack{
            if cameraManager.authStatus == .authorized {
                CameraPreview(session: cameraManager.session)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            } else {
                Text("ERROR")
            }
        }
        .onAppear {
            cameraManager.run()
        }
        .onDisappear {
            cameraManager.stop()
        }
    }
}

#Preview {
    //    CameraView(cameraManager: CameraManager())
}
