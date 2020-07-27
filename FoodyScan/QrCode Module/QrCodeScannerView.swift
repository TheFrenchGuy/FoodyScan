//
//  QrCodeScannerView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

struct QrCodeScannerView: UIViewRepresentable { // show the CameraPreview view in SwiftUI.
    
    //translate the SwiftUI state and lifecycle events to UIKit
    
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr, .ean8, .ean13] //What barcode are supported, can be changed later depending on the user needs
    typealias UIViewType = CameraPreview //Revers to the CameraPreview app to
    
    private let session = AVCaptureSession() // Create a CameraView and associate it with a AVCaptureSession.
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    
    func torchLight(isOn: Bool) -> QrCodeScannerView { //The ability to control the torch light of the device.
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if backCamera.hasTorch {
                try? backCamera.lockForConfiguration()
                if isOn {
                    backCamera.torchMode = .on
                } else {
                    backCamera.torchMode = .off
                }
                backCamera.unlockForConfiguration()
            }
        }
        return self
    }
    
    func interval(delay: Double) -> QrCodeScannerView {
        delegate.scanInterval = delay
        return self
    }
    
    func found(r: @escaping (String) -> Void) -> QrCodeScannerView {
        delegate.onResult = r
        return self
    }
    
    func simulator(mockBarCode: String)-> QrCodeScannerView{
        delegate.mockData = mockBarCode
        return self
    }
    
    func setupCamera(_ uiView: CameraPreview) {  //The ability to setup the scanning interval from the SwiftUI view as a modifier.
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {
                session.sessionPreset = .photo
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    
                    metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                
                uiView.backgroundColor = UIColor.gray
                previewLayer.videoGravity = .resizeAspectFill
                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer
                
                session.startRunning()
            }
        }
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<QrCodeScannerView>) -> QrCodeScannerView.UIViewType {
        let cameraView = CameraPreview(session: session)
        
        
        //The ability to set the mock data for use during simulation or UI Testing.

        #if targetEnvironment(simulator)
        cameraView.createSimulatorView(delegate: self.delegate)
        #else
        checkCameraAuthorizationStatus(cameraView)
        #endif
        
        return cameraView
    }
    
    static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        uiView.session.stopRunning()
    }
    
    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) { //The ability to request permission to use the camera
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            var isActive = true
            while(isActive) {
                DispatchQueue.main.sync {
                    if !self.session.isInterrupted && !self.session.isRunning {
                        isActive = false
                    }
                }
                sleep(1)
            }
        }
    }
    
    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<QrCodeScannerView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}

struct QrCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeScannerView()
    }
}
