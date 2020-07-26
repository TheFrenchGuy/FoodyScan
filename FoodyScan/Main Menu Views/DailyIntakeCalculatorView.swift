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
    @State var status = UserDefaults.standard.value(forKey: "birthdate") as? Date ?? Date()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all) //Used to change background color
        
            VStack(alignment: .leading) {
                GenderPicker()
                    .padding(.vertical, 20)
                
                DatePicker(selection: $userSettings.birthdate, in: ...Date(), displayedComponents: .date) {
                               Text("Select your birthdate") //Allows the user to select their birthdate
                           }.labelsHidden()

                           Text("Your birthdate is \(userSettings.birthdate, formatter: dateFormatter)") //
                    
                HeightWeightView()
                
                DropDownActivity(filledout: self.$filledout) //Passes if var to check if the form is filled out
                
            
                Button(action: {
                        print("success setup") //Debug Only
                        UserDefaults.standard.set(true, forKey: "setup") //The user has already previously logged in therefore he doesnt need to complete the DailyIntake Calculator
                        NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
                    
                    self.userSettings.dailyintakekcal = self.CaloriesIntake(birthdate: self.userSettings.birthdate, gender: self.userSettings.gender, weight: self.userSettings.weight, height: self.userSettings.height, Activitylevel: self.userSettings.activitylevel) //So once the user clicks to finish setup his daily intake calculator can be calculated
                    
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
//            }
        }
        .onAppear {
             
             NotificationCenter.default.addObserver(forName: NSNotification.Name("birthdate"), object: nil, queue: .main) { (_) in
                 
                 self.status = UserDefaults.standard.value(forKey: "birthdate") as? Date ?? Date()
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
                Text( selected == "" ? "What your activity level? " : selected) //Default value to trigger the user
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
                self.userSettings.activitylevel = 1 //Stores to device storage the activity level
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
                self.userSettings.activitylevel = 2 //Stores to device storage the activity level
            }) {
                Text("Easy exercise (2-3 times/week)")
                .padding()
                if selected == "Easy exercise (2-3 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("3")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = 3 //Stores to device storage the activity level
            }) {
                Text("Moderate exercise (4 times/week)")
                .padding()
                if selected == "Moderate exercise (4 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("4")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = 7 //Stores to device storage the activity level
            }) {
                Text("Daily exercise and physical job")
                .padding()
                if selected == "Daily exercise and physical job" {
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
