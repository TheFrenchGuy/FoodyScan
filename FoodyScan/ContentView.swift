//
//  ContentView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
 
 struct ContentView: View {
    var body: some View {
            Home()
     }
 }
 
 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 struct Home : View {
     
     @State var show = false //will if true show the SignUp view
     @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false //Wethever the user is logged in
     @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user is logged in
    
     var body: some View{
             NavigationView{
                 VStack{
                     
                    if self.status{
                        if self.setup { //So if already logged in the past then it will go straight to the main menu
                            HomeScreenView()
                        } else { //if it has not logged in before goes to the Daily Intake Calc
                            DailyIntakeParrallax()
                        }
                    }
                    
                    else{
                            
                         ZStack{
                             
                             NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                                 //Sends to SignUp view
                                 Text("")
                             }
                             .hidden()
                             
                             Login(show: self.$show)
                         }
                     }
                 }
                 .navigationBarTitle("")
                 .navigationBarHidden(true)
                 .navigationBarBackButtonHidden(true)
                 .onAppear {
                     
                     NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                         
                         self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("setup"), object: nil, queue: .main) { (_) in
                                        
                        self.setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false
                        }
                    }
                }
             }
             .navigationViewStyle(StackNavigationViewStyle())
             
         }
 }
 
struct SimpleButtonStyle: ButtonStyle { // Used to make a neumorphic button
    func makeBody(configuration: Self.Configuration) -> some View { //Can be applied to a button by .buttonstyle()
        configuration.label
        .padding(15)
        .background(
            Group {
                if configuration.isPressed {
                    Capsule()
                        .fill(Color.offWhite)
                } else { // return either a flat circle if the button is pressed, or return our current shadowed circle
                    Capsule()
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                }
            }
        )
    }
}

extension Color { //Create an extension color for the view in order to make the neumorphic design stand out more
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}


                 
