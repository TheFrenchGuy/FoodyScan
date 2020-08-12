//
//  MenuView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 24/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import CoreHaptics

struct MenuView: View {
    @State private var engine: CHHapticEngine?
    @State private var showQrView = false
    @Environment(\.managedObjectContext) var productenv //Neccesary as sets the view from different hiearchay can also sync up with the coredata stack
    var username = UserDefaults.standard.string(forKey: "UserName") ?? "Error"
    var email =  UserDefaults.standard.string(forKey: "email") ?? "Error" 
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome")
                    .foregroundColor(.gray)
                    .font(.title)
                GradientText(title: username, size: 20, width: 70)
                    .padding(.top, 12)
            }.padding(.top , 150)
            HStack {
                NavigationLink(destination: ScannerView(showSelf: $showQrView), isActive: $showQrView){ //Goes to the QR scanning view. Only shown when the showQRView is true.
                
                    Image(systemName: "barcode.viewfinder")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Barcode Scanner")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .onAppear(perform: prepareHaptics)
            .onTapGesture(perform: complexSuccess)
            .padding(.top, 30)
            HStack {
                
                NavigationLink(destination: PastScansView().environment(\.managedObjectContext, self.productenv)) { //Selectes which env to take from for the Core Data has otherwise the app will crash when trying to fetch the past products scans.
                    Image(systemName: "cart")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Past Scan")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                NavigationLink(destination: DailyIntakeView()) {
                    Image(systemName: "chart.bar")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Daily Intake")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer(minLength: 120)
            
            HStack {
                
                NavigationLink(destination: LottieView(filename: "QrCodeLottie", speed: 0.6)) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
            
    }
        func prepareHaptics() {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
                print("Haptic not supported by device")
                return
            }

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
    
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
