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
     @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false //Wethever the user is logged in
     @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user is logged in
    
     var body: some View{
            NavigationView {
                VStack {
                    if self.status{
                        if self.setup { //So if already logged in the past then it will go straight to the main menu
                            HomeScreenView()
                        } else { //if it has not logged in before goes to the Daily Intake
                            DailyIntakeParrallax() //Where the user will be able to continue with the setup of the account
                        }
                    }
                    else {
                        ZStack {
                            Color.offWhite.edgesIgnoringSafeArea(.all)
                            
                            VStack{
                            HStack(alignment: .center) {
                                Image("FoodyScanLargeIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(18)
                                Text("Foody Scan")
                                .foregroundColor(Color("Color"))
                                    .font(.system(size: 28, weight: .heavy))
                            }
                                VStack {
                                    Text("Welcome to FoodyScan")
                                        .font(.system(size: 28, weight: .heavy))
                                    Text("The application the keeps track of your intake")
                                        .font(.system(size: 15))
                                }
                                
                                Spacer()
                                NavigationLink(destination: TermsView()) {
                                    Text("Get Started")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                }.background(Color("Color"))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                .padding(.bottom, 25)
                            }.padding(.top, 30)
                        }
                    }
                    
                
                    
                }.navigationBarTitle("")
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
            }.navigationViewStyle(StackNavigationViewStyle())
            //Neccessary in order to display the app as a single view other wise it will not work properly when navigation link are used or a large display is used
             
         }
 }
 


extension Color { //Create an extension color for the view in order to make the neumorphic design stand out more
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}


                 
