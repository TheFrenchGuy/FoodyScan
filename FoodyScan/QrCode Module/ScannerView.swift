//
//  ScannerView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import CoreHaptics
struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ScannerViewModel() //Refers to the scanner view model
    @Binding var showSelf: Bool //Whever the product view is shown
    @ObservedObject var getData = JSONParserFood()
    @State private var engine: CHHapticEngine?
    var body: some View {
        GeometryReader { bounds in
            ZStack { //Used a ZStack as the camera view will be in at the back so will take the entire screen
                
                if self.viewModel.lastQrCode != "" {
                    
                    if self.viewModel.lastQrCode == "first scan" { //If first scan will rederect to scanning page in order to scan first product
                        QrCodeScannerView()
                                .found(r: self.viewModel.onFoundQrCode)
                                .torchLight(isOn: self.viewModel.torchIsOn)
                                .interval(delay: self.viewModel.scanInterval)
                    }
                    else { ProductInfoView(showSelf: self.$showSelf) } //then will always proceed to the show the product view
                }
                
                else {
                QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                
                
                VStack {
                    VStack {
                        Text("Keep scanning for QR-codes")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text(self.viewModel.lastQrCode)
                            .bold()
                            .lineLimit(5)
                            .padding()
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    HStack {
                        Button(action: {
                            self.viewModel.torchIsOn.toggle()
                        }, label: {
                            Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                                .imageScale(.large)
                                .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color("Color"))
                                .padding()
                        })
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    
                }.padding()
                }
                
            }
        .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
            
            HStack {
                Button(action: {
                    self.complexSuccess()
                    self.goHome() //Allows the user if the app is launched from shortcute to go back to main screen
                    self.showSelf = false
                    self.presentationMode.wrappedValue.dismiss()
                    self.viewModel.lastQrCode = ""// So that it returns to the previous view
                }) { //UI at the top of the screen
                    HStack {
                        GradientImage(image: "chevron.left", size: 18, width: 20 )
                            .padding(.top, 20)
                        GradientText(title: "Main Menu", size: 16, width: 180)
                            .padding(.top, 10)
                    }.padding(.trailing, bounds.size.width - 375)
                        .onAppear(perform: self.prepareHaptics)
                }
                
                
                
                
                if self.viewModel.lastQrCode == "" {
                    Button(action: {
                        self.complexSuccess()
                        self.showSelf = true// So that it returns to the previous view
                        self.viewModel.lastQrCode = "Not Scanned"
                        
                    }) { //UI at the top of the screen
                        HStack {
                            GradientImage(image: "barcode.viewfinder", size: 18, width: 20)
                                
                                .padding(.top, 20)
                            GradientText(title: "No barcode", size: 16, width: 100)
                                .padding(.top, 10)
                        }.onAppear(perform: self.prepareHaptics)
                            
                    }
                }
        })
                .navigationBarTitle(Text(""))
        } //No title for the view name
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func goHome() { //Return the user to the main screen of the app launch
        UserDefaults.standard.set(false, forKey: "showScan") //Sets the status to be true and stored in memory so next app launch the user wont have to login
        NotificationCenter.default.post(name: NSNotification.Name("showScan"), object: nil)
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(showSelf: .constant(true))
    }
}
