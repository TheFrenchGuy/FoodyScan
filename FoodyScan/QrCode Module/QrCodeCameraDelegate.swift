//
//  QrCodeCameraDelegate.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import AVFoundation

//Responsible for handling the metadata output, checking if a QR-code was found and informing the parent View of the QR-code value

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    //Adopt the AVCaptureMetadataOutputObjectsDelegate protocol in order to listen for new metadata objects which were detected in the camera feed.
    var scanInterval: Double = 1.0 //How often to scan for the QR code
    var lastTime = Date(timeIntervalSince1970: 0) //When was the last time to scan
    
    var onResult: (String) -> Void = { _  in } //What happens on result
    var mockData: String? //Simulator data only
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    @objc func onSimulateScanning(){ //Simulator device use only so can test without real device
        foundBarcode(mockData ?? "Simulated QR-code result.") //Data return to the ScannerViewModel
    }
    
    func foundBarcode(_ stringValue: String) { //Get called once the barcode has been found
        let now = Date() //Current time
        if now.timeIntervalSince(lastTime) >= scanInterval { //If the time interval since last time is more than the scan interval then the QR code is copied to memory
            
            //Usefull as saves ressources and not knowing scan the wrong QR-code
            lastTime = now
            self.onResult(stringValue) //Stored the result
        }
    }
}
