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
import UserNotifications
 
 struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false //Wethever the user is logged in
    @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user is logged in
    @State var showScan = UserDefaults.standard.value(forKey: "showScan") as? Bool ?? false //In order to show if the user chooses from the shortcut menu to launch the scanner directly
    
    @ObservedObject var userSettings = UserSettings() //Fetches the userSettings stored onto device storage
    @ObservedObject var eatenToday = EatenToday() //What the user has eaten today
    var body: some View {
        
        NavigationView() {
            if self.status{
                if self.setup { //So if already logged in the past then it will go straight to the main menu
                    if self.showScan { //Can only be accessed if the app is lauchned from the shortcut menu 
                        ScannerView(showSelf: $showScan)
                    } else { //Rest of the cases
                    HomeScreenView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                                    let timediff = Int(Date().timeIntervalSince(self.eatenToday.startTime)) //If the app has been launched for more than a day since the first scan the the variables are whipped
                                    if timediff >= 86400 {
                                        self.eatenToday.firstItemDay = true
                                        self.eatenToday.sugarToday = 0.0
                                        self.eatenToday.proteinToday = 0.0
                                        self.userSettings.eatentoday = 0.0
                                        self.eatenToday.carbohydratesToday = 0.0
                                        self.eatenToday.fatToday = 0.0
                                        self.eatenToday.fiberToday = 0.0
                                        self.eatenToday.saltToday = 0.0
                                    }
                                }
                    }
                } else { //if it has not logged in before goes to the Daily Intake
                    DailyIntakeParrallax()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true) //Where the user will be able to continue with the setup of the account
                }
            } else {
                NavigationLink(destination: Home(), isActive: .constant(true)) { //Sends to welcome screens
                    EmptyView()
                }.navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
         //Looks for if the value has changes so it can change the view
             NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                 
                 self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("setup"), object: nil, queue: .main) { (_) in
                                
                self.setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false
                }
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("showScan"), object: nil, queue: .main) { (_) in
                            
            self.showScan = UserDefaults.standard.value(forKey: "showScan") as? Bool ?? false
            }
            }
        }
     }
 }
 
 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 struct Home : View {
     @Environment(\.colorScheme) var colorScheme
    
//     @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false //Wethever the user is logged in
//     @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user is logged in
    
     var body: some View{
            //NavigationView {
                VStack {
//                    if self.status{
//                        if self.setup { //So if already logged in the past then it will go straight to the main menu
//                            HomeScreenView()
//                        } else { //if it has not logged in before goes to the Daily Intake
//                            DailyIntakeParrallax() //Where the user will be able to continue with the setup of the account
//                        }
//                    }
//                    else {
                        ZStack {
                            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                            
                            VStack{
                                HStack(alignment: .center) {
                                Image("FoodyScanLargeIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(18)
                                    .padding()
                                //Text("Foody Scan")
                                  //  .foregroundColor(Color("Color"))
                                    //    .font(.system(size: 28, weight: .heavy))
                                    GradientText(title: "Foody Scan", size: 28, width: 165)
                            }
                                VStack {
                                    Text("Welcome to FoodyScan")
                                        .font(.system(size: 28, weight: .heavy))
                                    Text("The application that keeps track of your intake")
                                        .font(.system(size: 15))
                                }
                                
                                if self.colorScheme == .light {
                                    LottieView(filename: "QrCodeLottie", speed: 0.7, loop: .playOnce)
                                }
                                if self.colorScheme == .dark {
                                    LottieView(filename: "QrCodeLottieDark", speed: 0.7, loop: .playOnce)
                                }
                                
                                Spacer()
                                NavigationLink(destination: TermsView()) {
                                    Text("Get Started")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                }.background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(10)
                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                .padding(.bottom, 25)
                            }.padding(.top, 30)
                        }
                    //}
                    
                
                    
                }.navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
//                .onAppear {
//
//                     NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
//
//                         self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
//
//                    NotificationCenter.default.addObserver(forName: NSNotification.Name("setup"), object: nil, queue: .main) { (_) in
//
//                        self.setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false
//                        }
//                    }
//                }
         //}.navigationViewStyle(StackNavigationViewStyle())
            //Neccessary in order to display the app as a single view other wise it will not work properly when navigation link are used or a large display is used
             
         }
 }







                 
