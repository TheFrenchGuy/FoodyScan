//
//  HomeScreenView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreHaptics
import SDWebImageSwiftUI
struct HomeScreenView: View {
   @State private var engine: CHHapticEngine?
   @State var showMenu = false
   
   var body: some View {
    
       let drag = DragGesture()
           .onEnded {
               if $0.translation.width < -100 {
                   withAnimation {
                       self.showMenu = false //When the user drags the menu it will close it, with an animation
                   }
               }
       }
       
       
       return NavigationView {
           GeometryReader { geometry in
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Neccessary in order to fix a bug where the color scheme would slightly show in the background
               ZStack(alignment: .leading) {
                   MainView(showMenu: self.$showMenu) //Shows the main View
                       .frame(width: geometry.size.width, height: geometry.size.height)
                       .offset(x: self.showMenu ? geometry.size.width / 2 : 0)
                       .disabled(self.showMenu ? true : false)
                   if self.showMenu {
                       MenuView() //It will shows the side menu view
                           .frame(width: geometry.size.width/2)
                           .transition(.move(edge: .leading))
                   }
               }
               .gesture(drag)
           }
           .navigationBarTitle(Text("Main Menu"), displayMode: .inline)
           .navigationBarItems(leading: (
               Button(action: {
                withAnimation(.linear) {
                       self.showMenu.toggle() //So when the user taps on the icon it will change it to signify a change of state
                       self.complexSuccess() //Gives haptic feedback to the user
                   }
               }) {
                
                if self.showMenu {
                    GradientImage(image: "chevron.down", size: 16, width: 60)
                       .imageScale(.large)
                        .padding(.top, 24)
                }
                else {
                   GradientImage(image: "line.horizontal.3.decrease", size: 16, width: 60)
                       .imageScale(.large)
                    .padding(.top, 24)
                }
               }.onAppear(perform: prepareHaptics)
           ))
       }
      .navigationViewStyle(StackNavigationViewStyle()) //Only one view on the screen at once
           
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



struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
