//
//  DailyIntakeCalculatorView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 24/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct DailyIntakeCalculatorView: View {
    @State var show = false //Whever to show or not the birthdate view
    @ObservedObject var userSettings = UserSettings() //Where all of the user info are stored
    @State var filledout = false // Whever the form is filled out
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all) //Used to change background color
            
            if self.show {
                BirthView(show: self.$show)//Show the birthdate view so doesnt get on top screen
            } else {
            
            VStack(alignment: .leading) {
                GenderPicker()
                    .padding(.vertical, 20)
                
                
                Button(action: {
                    self.show.toggle() //Loads the birthdate view
                    
                    }) {
                        HStack(alignment: .center, spacing: 20) {
                            Text("Select date of birth")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                        }.foregroundColor(Color("Color"))
                    }
                    .buttonStyle(SimpleButtonStyle())
                    .padding(.horizontal, 80)
                    
                HeightWeightView()
                
                DropDownActivity(filledout: self.$filledout) //Passes if var to check if the form is filled out
                
            
                Button(action: {
                        print("success setup") //Debug Only
                        UserDefaults.standard.set(true, forKey: "setup") //The user has already previously logged in therefore he doesnt need to complete the DailyIntake Calculator
                        NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
                        
                    }) {
                    
                    if self.filledout == false {
                        Text("Please fill out the whole form") // If the user has not filled out all of the fields
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.top, 25)
                            .padding(.horizontal, 30)
                    } else {
                        HStack {
                            Text("Continue") //Changes the form to the Home Screen
                            Image(systemName: "arrow.right")
                                
                            }
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color("Color"))
                            .cornerRadius(10)
                            .padding(.top, 25)
                            .padding(.horizontal, 30)
                        }
                    }.disabled(self.filledout == false)
                }
            }
        }
    }
}

struct GenderPicker: View {
    @ObservedObject var userSettings = UserSettings() //Where all of the user info are stored
    var body: some View {
        VStack {
            HStack() {
                Text("Please select your gender")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .padding(.trailing, 180)
            }
            Picker(selection: $userSettings.gender, label: Text("Gender")) {
                ForEach(userSettings.genders, id: \.self) { gender in
                    Text(gender) //Allows the user to choose between 3 genders
                }
            }
                
            .pickerStyle(SegmentedPickerStyle()) //So that the picker is all horizontal
            .padding()
            .background(Color.offWhite)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)// Shadows neccesary to make a neumophism design
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .animation(.spring()) //Animation to make it smoother
        }
    }
    func DailyIntakeAlgo() {
        // Variable needed for calcualtion
        // These variable will be collected by the UI later
        var age: Int = 10 //years
        var gender: String = "female" // gender
        var weight: Double = 40 //kg
        var height: Int = 150 //cm
        var Activitylevel: Int = 1 //Listed below

        // Activitylevel 1 = No or little exercise
        // Activity level 2 = Easy exercise (2-3 times/ week)
        // Activty level 3  = Moderate exercise  (4 times / week)
        // Activity level 4  = Active exercise (5 times/ week)
        // Activity level 5 = Very active exercise (5 times intense / week)
        // Activty level 6 = Day by day exercise
        // Activty level 7 = Daily exercise and physical job


        // Variable returned to the user
        var dailykcal: Int


        func CaloriesIntake (age: Int, gender: String, weight: Double, height: Int, Activitylevel: Int)  -> Double {
            
            if gender == "female" {
                let BMR = 10 * weight + (6.25 * Double(height)) - (5 * Double(age)) - 161
                
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
            
            if gender == "male" {
                let BMR = 10 * weight + (6.25 * Double(height)) - (5 * Double(age)) + 5
                
               switch Activitylevel {
                   case 1 :
                       return BMR * 1.2000
                   case 2 :
                       return BMR * 1.3751
                   case 3 :
                       return BMR * 1.41870
                   case 4 :
                       return BMR * 1.46251
                   case 5 :
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
                    case 2 :
                        return BMR * 1.3751
                    case 3 :
                        return BMR * 1.41870
                    case 4 :
                        return BMR * 1.46251
                    case 5 :
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

}

struct HeightWeightView: View {
    @ObservedObject var userSettings = UserSettings() //Where all of the user info are stored
    
    var body: some View {
        VStack {
            VStack {
                Text("Please select your height")
                    .bold()
                Slider(value: $userSettings.height, in: 120...220, step: 0.5) //Ranged between 120cm and 220cm with an increase of 0.5cm
                    .accentColor(Color("Color")) //So that the slider matches the main color of the app
                Text("You are \(userSettings.height, specifier: "%g") cm") //Feedback to the user their height
            }
            
            .padding()
            
            VStack {
                Text("Please select your weight")
                    .bold()
                Slider(value: $userSettings.weight, in: 40...150, step: 0.5) //Ranged between 40kg and 150kg with a step of 0.5kg
                    .accentColor(Color("Color")) //So that the slider matches the main color of the app
                Text("You weight \(userSettings.weight, specifier: "%g") kg") //Feedback of the user their weight
            }
            .padding()
        }
    }
}

struct BirthView : View {
    
    @Binding var show:Bool //Whever the birthview should be on the screen
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    } //Clean the birthdate to the user
    //Var stores it has a whole for better calculations
    
    @ObservedObject var userSettings = UserSettings() //Where all of the user info are stored
    
    var body: some View {
        VStack {
            
            Text("Select your date of birth below:")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 30)
                .padding(.bottom, 20)
            
            Text("This is neccessary in order to calculate your age")
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            
            DatePicker(selection: $userSettings.birthdate, in: ...Date(), displayedComponents: .date) {
                Text("Select your birthdate") //Allows the user to select their birthdate
            }.labelsHidden()

            Text("Your birthdate is \(userSettings.birthdate, formatter: dateFormatter)") //Feedback to the user what is their birthdate

        
            Button(action: {
                self.show.toggle() //Returns to the main of the form
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
            .foregroundColor(Color("Color"))
            }.buttonStyle(SimpleButtonStyle()) //Declared in Content view
        }
    }
}
struct DailyIntakeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeCalculatorView() //Debug only
    }
}

struct DropDownActivity: View {
    @State var expand = false //whever the dropdown menu is all shown
    @State var selected = "" // Which option is selected
    @Binding var filledout: Bool //Whever the form is filled out
    @ObservedObject var userSettings = UserSettings() //Where all of the user info are stored
    
    
    var body: some View{
        VStack(alignment: .center) {
            VStack() {
            HStack(){
                Text( userSettings.activitylevel == "" ? "What your activity level? " : userSettings.activitylevel) //Default value to trigger the user
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
            Image(systemName: expand ? "chevron.up" : "chevron.down") //Changes the images based if tapped or not
                .resizable()
                .frame(width: 13, height: 6)
                .foregroundColor(.black)
            }
            .onTapGesture {
            self.expand.toggle()
        }
        if expand {
            Button(action: {
                print("1")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = "No or little exercise/sedentary" //Stores to device storage the activity level
            }) {
                Text("No or little exercise/sedentary")
                .padding()
                if selected == "No or little exercise/sedentary" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("2")
                self.expand.toggle()  //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = "Easy exercise (2-3 times/week)" //Stores to device storage the activity level
            }) {
                Text("Easy exercise (2-3 times/week)")
                .padding()
                if userSettings.activitylevel == "Easy exercise (2-3 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("3")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = "Moderate exercise (4 times/week)" //Stores to device storage the activity level
            }) {
                Text("Moderate exercise (4 times/week)")
                .padding()
                if userSettings.activitylevel == "Moderate exercise (4 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("4")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = "Daily exercise and physical job" //Stores to device storage the activity level
            }) {
                Text("Daily exercise and physical job")
                .padding()
                if userSettings.activitylevel == "Daily exercise and physical job" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)

        }
            
    }
    
    .padding()
    .background(Color.offWhite)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        .animation(.spring())
        .padding(.horizontal, 60)
        }
    }
}
