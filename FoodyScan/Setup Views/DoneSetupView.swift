//
//  DoneSetupView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 28/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct DoneSetupView: View { //Just to go give feedback to the user that the data he has finished setting up his account, Also allows the app to store to refresh the variables and to store the daily intake calculator into the  device memory
    @Environment(\.colorScheme) var colorScheme

    @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user has setup the account links back to the sign up screen
    @State var scale: CGFloat = 1 //Necessary for the animation on lauch of the screen
    @ObservedObject var userSettings = UserSettings() // Where all of the user variables are stored
    @State var notificationhelper = UserDefaults.standard.value(forKey: "notificationhelper") as? Bool ?? false
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            if self.setup { //The user has succesfully logged in then the screen goes to the home screen
                HomeScreenView()
                
            }
            else {
                GeometryReader { bounds in
                ZStack {
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ZStack(alignment: .top) {
                            ShapeView().offset(x: -80, y : -389).shadow(radius: 12)
                        }
                    }
                    VStack {
                    
                        Text("Finished Setup")
                            .font(.system(size: 32))
                            .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                            .padding(.top, 120)
                        Button(action: {
                            
                            UserDefaults.standard.set(true, forKey: "notificationhelper")
                            NotificationCenter.default.post(name: NSNotification.Name("notificationhelper"), object: nil) //Put a backend notification to inform app the data has been written
                            UserDefaults.standard.set(true, forKey: "setup") // This means that the user is logging in the first time so he must complete the daily intake calculator
                            NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil) //Put a backend notification to inform app the data has been written
                            
                            self.userSettings.dailyintakekcal = self.CaloriesIntake(birthdate: self.userSettings.birthdate, gender: self.userSettings.gender, weight: self.userSettings.weight, height: self.userSettings.height, Activitylevel: self.userSettings.activitylevel) //So once the user clicks to finish setup his daily intake calculator can be calculated
                            
                            
                        }) {
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .mask(Circle())
                                    .frame(width: bounds.size.width - 200)
                                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)

                                LottieView(filename: self.colorScheme == .light ? "AcceptedLottie" : "AcceptedDarkLottie", speed: 1, loop: .playOnce)
                                    .frame(width: bounds.size.width - 170)
//                             Image(systemName: "checkmark")
//                                 .foregroundColor(Color("BackgroundColor"))
//                                 .font(.system(size: 54))
                             }
                        }
                        
                        
                         
                    }
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ShapeView().offset(x: 80, y : 389).shadow(radius: 12)
                    }
                }
                }
            }
        }
        .navigationBarHidden(false)
        .onAppear {

            NotificationCenter.default.addObserver(forName: NSNotification.Name("setup"), object: nil, queue: .main) { (_) in
                                
                self.setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false
                }
            
            
            //Animation when changing the view so it is nicer to look at
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)

                return withAnimation(repeated) {
                    self.scale = 0.5
                }
            }
        
    }
    
    func CaloriesIntake (birthdate: Date, gender: String, weight: Double, height: Double, Activitylevel: Int)  -> Double { //Allow the computer to calculate the number of calories the user should eat refers to https://www.thecalculator.co/health/Calorie-Calculator-125.html
        let currentdate = Date()
         var age:Int{ return Int((DateInterval(start: birthdate, end: currentdate).duration) / 31557600)} //Calculate the time differenc between birthdate and today date and print the amount of years lived
        print(age) //Debug Only
        print(Activitylevel) //Debug Only
        if gender == "Female" {
            let BMR = 10 * weight + (6.25 * Double(height)) - (5 * Double(age)) - 161 //Based on the Mifflin-St Jeor equation used for the estimation of the BMR
            print(BMR)
            //Depending on the activity level more or less calories are needed to be eaten a day
            if Activitylevel == 1 {
                let coef = 1.20000
                let cal = BMR * coef
                return cal
            }
            if Activitylevel == 2 {
                let coef = 1.3751
                let cal = BMR * coef
                return cal
            }
            if Activitylevel == 3 {
                let coef = 1.41870
                let cal = BMR * coef
                return cal
            }
            if Activitylevel == 4 {
                let coef = 1.46251
                let cal = BMR * coef
                return cal
            }
            
            if Activitylevel == 5 {
                let coef = 1.5500
                let cal = BMR * coef
                return cal
            }
            
            if Activitylevel == 6 {
                let coef = 1.6376
                let cal = BMR * coef
                return cal
            }
            
            else {
                let coef = 1.9100
                let cal = BMR * coef
                return cal
            }
            
            
            
        }
        
        if gender == "Male" {
            let BMR = 10 * weight + (6.25 * Double(height)) - (5 * Double(age)) + 5
            
           switch Activitylevel {
               case 1 :
                   return BMR * 1.2000
               case 2:
                   return BMR * 1.3751
               case 3 :
                   return BMR * 1.41870
               case 4 :
                   return BMR * 1.46251
               case 5:
                   return BMR * 1.5500
               case 6 :
                   return BMR * 1.6376
               case 7 :
                   return BMR * 1.9100
               default:
                   return BMR
           }
        }
        
        else {
            let BMR = 10 * weight + (6.25 * Double(height)) - (5 * Double(age)) + 5
            
            switch Activitylevel {
                case 1 :
                    return BMR * 1.2000
                case 2:
                    return BMR * 1.3751
                case 3 :
                    return BMR * 1.41870
                case 4 :
                    return BMR * 1.46251
                case 5:
                    return BMR * 1.5500
                case 6 :
                    return BMR * 1.6376
                case 7 :
                    return BMR * 1.9100
                default:
                    return BMR
            }
        }
        
    }
    
    
}

struct DoneSetupView_Previews: PreviewProvider {
    static var previews: some View {
        DoneSetupView()
    }
}


