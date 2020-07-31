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
    //Defines how often we are going to try looking for a new QR-code in the camera feed
    let scanInterval:Double = 1.0
    
    @Published var torchIsOn: Bool = false   //Whever the torch is going to be on (button added onto the view)
    
    @Published var lastQrCode: String{
        didSet {
            UserDefaults.standard.set(lastQrCode, forKey: "lastQrCode") //Stored onto device storage *facilitate moving views with the QR code*
        }
    }
    
    init() {
         self.lastQrCode = UserDefaults.standard.object(forKey: "lastQrCode") as? String ?? "5032439100179" //To initialiased the QR code to be saved and if there is an error then the field will be "not scanned"
    }
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code //QrCodeScanner is going to call whenever a new QR-code has been detected.
    }
}

