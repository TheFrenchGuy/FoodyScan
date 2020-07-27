//
//  CameraPreview.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import UIKit
import AVFoundation


class CameraPreview: UIView {
    
    private var label:UILabel?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    weak var delegate: QrCodeCameraDelegate?
    
    init(session: AVCaptureSession) { //Starts the camera live preview
        super.init(frame: .zero)
        self.session = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //Printed if there is an error during the camera preview
    }
    
    func createSimulatorView(delegate: QrCodeCameraDelegate){ //Only for the simulated devices won't show on user devices
        
        //Debug only
        self.delegate = delegate
        self.backgroundColor = UIColor.black
        label = UILabel(frame: self.bounds)
        label?.numberOfLines = 4
        label?.text = "Click here to simulate scan"
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func onClick(){ //Only for simulated devices debug only
        delegate?.onSimulateScanning()
    }
    
    override func layoutSubviews() { //For the Ui in the rest of the screen
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
    }
}
