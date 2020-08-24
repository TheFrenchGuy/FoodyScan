//
//  CalculatorHelpView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 14/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct CalculatorHelpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var engine: CHHapticEngine?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                ScrollView {
                
                    HStack(alignment: .center) {
                        Image("FoodyScanLargeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        GradientText(title: "Foody Scan", size: 24, width: 150)
                    }.frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 10)
                    
                    Text("How is your daily calorie intake calculated?")
                        .font(.title).bold()
                        .padding(.bottom, 10)
                    
                    
                    VStack(alignment: .leading) {
                        Text("The calorie calculator is based on Mifflin-St Jeor equation, the equation is used for the estimation of the BMR(Basal Metabolic Rate)")
                                               .fixedSize(horizontal: false, vertical: true)
                                               .padding(.bottom, 20)
                        Text("For male:")
                            .bold()
                            //.padding(.leading, 10)
                        ScrollView(.horizontal) {
                        GradientText(title: "BMR = 10 x Weight + 6.25 x Height - 5 x Age + 5", size: 16, width: Int(UIScreen.main.bounds.width + 50))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top)
                            .padding(.leading, 10)
                        }
                            
                        
                        
                    }.padding(.leading, 10)
                    
                    VStack(alignment: .leading) {
                        Text("For female:")
                            .bold()
                        
                        ScrollView(.horizontal) {
                            GradientText(title:" BMR = 10 x Weight + 6.25 x Height - 5 x Age - 161", size: 16, width: Int(UIScreen.main.bounds.width + 60))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top)
                            .padding(.leading, 10)
                            
                        }
                            //.padding(.leading, UIScreen.main.bounds.width - 365)
                        Text("The BMR value estimated by the above formulas is further on multiplied by an approximate factor/coefficient for each activity level.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 5)
                    }.padding(.leading, 10)
                    
                        
                    VStack(alignment: .leading) {
                        VStack() {
                            Text("No or little exercise/sedentary - 1.2")
                                .padding(.bottom, 5)
                            Text("Easy exercise (2-3 times/week) - 1.3751")
                                .padding(.bottom, 5)
                            Text("Moderate exercise (4 times/week) - 1.42")
                                .padding(.bottom, 5)
                            Text("Daily exercise and physical activity/job - 1.91")
                            }.frame(width: UIScreen.main.bounds.width - 66, height: UIScreen.main.bounds.height * 0.15).padding()
                             .background(Color("BackgroundColor"))
                             .cornerRadius(5.0)
                             .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                             .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                             .padding()
                        
                        Text("This basically means that two people with similar data but with different lifestyles will have different intake needs.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 40)
                    }.padding(.leading, 10)
                    
                    HStack {
                        Text("Information gotten from this article")
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                    Button(action: {
                        self.complexSuccess()
                        if let url = URL(string: "https://www.thecalculator.co/health/Calorie-Calculator-125.html") { //Switches to the either safari where my twitter profile will be loaded or if twitter is installed it will open the twitter app
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Link")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color("Color"))
                            .onAppear(perform: prepareHaptics)
                    }
                    }.frame(width: UIScreen.main.bounds.width - 10)
                    .padding(.bottom, 20)



                    
                }.frame(width: UIScreen.main.bounds.width)
            }
        }.frame(width: UIScreen.main.bounds.width)
            .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
            Button(action: {
                self.complexSuccess()
                self.presentationMode.wrappedValue.dismiss()// So that it returns to the previous view
            }) { //UI at the top of the screen
                HStack {
                    GradientImage(image: "chevron.left", size: 18, width: 20 )
                        .padding(.top, 20)
                    GradientText(title: "Main Menu", size: 16, width: 180)
                        .padding(.top, 10)
                }.onAppear(perform: prepareHaptics)
        })
        .navigationBarTitle(Text(""))
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

struct CalculatorHelpView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorHelpView()
    }
}
