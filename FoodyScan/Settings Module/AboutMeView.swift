//
//  AboutMeView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 19/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreHaptics

struct AboutMeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var engine: CHHapticEngine?
    var body: some View {
        ZStack(alignment: .top) {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Sets the background of the app so it can be constant throughout the UI
            ScrollView {
                VStack {
                    HStack(alignment: .center) {
                        Image("FoodyScanLargeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        GradientText(title: "Foody Scan", size: 24, width: 165)
                        
                        .font(.system(size: 24, weight: .heavy))
                    }
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    //.padding(.top, 50)
                    
                    Text("Version: 0.1 Beta")
                        .font(.footnote)
                        .padding(.bottom, 10)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            
                        }) {
                            Text("Privacy Policy")
                                .font(.caption)
                                .foregroundColor(Color("Color"))
                        }.padding()
                        
                        Button(action: {
                            
                        }) {
                            Text("Terms of Use")
                                .font(.caption)
                                .foregroundColor(Color("Color"))
                        }.padding()
                    }
                    
                    Text("Copyright © 2020 TheFrenchGuy")
                    
                    Divider().frame(width: UIScreen.main.bounds.width - 20)
                    
                    VStack(alignment: .leading) {
                        Text("About the Developer:").bold().padding(.bottom, 5)
                        Text("I am a 17 year old self taught software programmer, I have developed this app for my Alevel Computer Science coursework, most of the app is made using only swiftUI with few UIKit elements, I am currently looking for work experience near Amsterdam.").font(.subheadline).padding(.bottom, 10)
                        
                        Text("Data Provided by OpenFoodFacts:").fontWeight(.semibold).padding(.bottom, 5)
                        Text("Open Food Facts gathers information and data on food products from around the world.").font(.subheadline)
                        Text("Food product information (photos, ingredients, nutrition facts etc.) is collected in a collaborative way and made available to everyone and for all uses in a free and open database.").font(.subheadline)
                        
                        Text("Icon provided by Icons8").bold()//.padding(.bottom, 5)
                        Button(action: {
                            if let url = URL(string: "https://icons8.com") { //Switches to the either safari where my twitter profile will be loaded or if twitter is installed it will open the twitter app
                                UIApplication.shared.open(url)
                            }
                        }) {
                            
                            GradientText(title: "Click here to check their website", size: 12, width: Int(UIScreen.main.bounds.width) - 20)
                        }.padding(.leading, 5)
                    }.frame(width: UIScreen.main.bounds.width - 20, alignment: .leading).padding(.leading, 20)
                    
                    Divider().frame(width: UIScreen.main.bounds.width - 20)
                    
                    
                    Text("FoodyScan uses the following open source software:").font(.subheadline).padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Button(action: {
                            if let url = URL(string: "https://github.com/SDWebImage/SDWebImage") { //Switches to the either safari where my twitter profile will be loaded or if twitter is installed it will open the twitter app
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("• SDWebImage").font(.caption)
                            .foregroundColor(Color("Color"))
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://github.com/airbnb/lottie-android") { //Switches to the either safari where my twitter profile will be loaded or if twitter is installed it will open the twitter app
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("• Lottie").font(.caption)
                            .foregroundColor(Color("Color"))
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width - 20, alignment: .leading).padding(.leading, 20)
                    
                    Divider().frame(width: UIScreen.main.bounds.width - 20)
                    
                    
                }
                Text("User ID: \(Auth.auth().currentUser?.uid  ?? "Couldn't get use UID")").foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark).font(.caption)
            }
        }
        .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
            Button(action: {
                self.complexSuccess()
                self.presentationMode.wrappedValue.dismiss()
               // So that it returns to the previous view
            }) { //UI at the top of the screen
                HStack {
                    GradientImage(image: "chevron.left", size: 18, width: 20 )
                        .padding(.top, 20)
                    GradientText(title: "Main Menu", size: 16, width: 180)
                        .padding(.top, 10)
                }.onAppear(perform: prepareHaptics)
        })
        .navigationBarTitle(Text("")) //No title for the view name
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

}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
