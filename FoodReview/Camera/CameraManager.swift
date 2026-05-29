//
//  CameraModel.swift
//  FoodReview
//
//  Created by Hyeonwoo Choi on 5/9/26.
//

import AVFoundation
import SwiftUI
import Combine

@Observable
final class CameraManager: NSObject, ObservableObject, Sendable, AVCapturePhotoCaptureDelegate{
    
    var capturedImage: UIImage?
    var authStatus: AVAuthorizationStatus = .notDetermined
    
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var currentInput: AVCaptureDeviceInput?
    
    private let sessionQueue = DispatchQueue(label: "camera")
    
    override init(){
        super.init()
        checkAuth()
    }
    
    func checkAuth() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            authStatus = .authorized
            setupSession()
        case .notDetermined:
            authStatus = .notDetermined
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.authStatus = granted ? .authorized : .denied
                    if granted { self?.setupSession() }
                }
            }
        case .denied, .restricted:
            authStatus = .denied
        @unknown default:
            authStatus = .denied
        }
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else {return}
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera) else{
                self.session.commitConfiguration()
                return
            }
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
                self.currentInput = input
            }
            
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
                
                self.photoOutput.maxPhotoQualityPrioritization = .quality
            }
            
            self.session.commitConfiguration()
        }
    }
    
    func run() {
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stop() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func takePhoto() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            
            
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if error != nil { return }
        
        guard let imageData = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: imageData) else { return }
                
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = uiImage
        }
    }
    
    func reset() {
        capturedImage = nil
    }
    
}
