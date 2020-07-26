//
//  ScannerViewModel.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    //Defines how often we are going to tryh looking for a new QR-code in the camera feed
    let scanInterval:Double = 1.0
    
    @Published var torchIsOn: Bool = false    
    
    @Published var lastQrCode: String {
        didSet {
            UserDefaults.standard.set(lastQrCode, forKey: "lastQrCode")
        }
    }
    
    init() {
         self.lastQrCode = UserDefaults.standard.object(forKey: "lastQrCode") as? String ?? "Not Scanned"
    }
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
    }
}

