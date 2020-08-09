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
    @Binding var done: Bool
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
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Used to change background color
        
            VStack(alignment: .leading) {
                GenderPicker()
                    .padding(.vertical, 20)
                
                DatePicker(selection: $userSettings.birthdate, in: ...Date(), displayedComponents: .date) {
                               Text("Select your birthdate") //Allows the user to select their birthdate
                           }.labelsHidden()
                            .padding(.horizontal, 30)

                           Text("Date of birth: \(userSettings.birthdate, formatter: dateFormatter)") //Feedback to the user
                            .padding(.horizontal, 60)
                            .lineLimit(1)
                HeightWeightView()
                
                DropDownActivity(filledout: self.$filledout) //Passes if var to check if the form is filled out
                
            
                Button(action: {
                        print("success setup") //Debug Only
                        self.done = true
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
            .background(Color("BackgroundColor"))
            .cornerRadius(10)
            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
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
        DailyIntakeCalculatorView(done: .constant(false)) //Debug only
    }
}

struct DropDownActivity: View {
    @Environment(\.colorScheme) var colorScheme
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
                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                .lineLimit(1)
            Image(systemName: expand ? "chevron.up" : "chevron.down") //Changes the images based if tapped or not
                .resizable()
                .frame(width: 13, height: 6)
                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
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
                self.selected = "No or little exercise/sedentary" //Feedback to the user
            }) {
                Text("No or little exercise/sedentary")
                .padding()
                if selected == "No or little exercise/sedentary" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
            
            Button(action: {
                print("2")
                self.expand.toggle()  //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = 2 //Stores to device storage the activity level
                self.selected = "Easy exercise (2-3 times/week)" //Feedback to the user
            }) {
                Text("Easy exercise (2-3 times/week)")
                .padding()
                if selected == "Easy exercise (2-3 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
            
            Button(action: {
                print("3")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = 3 //Stores to device storage the activity level
                self.selected = "Moderate exercise (4 times/week)" //Feedback to the user
            }) {
                Text("Moderate exercise (4 times/week)")
                .padding()
                if selected == "Moderate exercise (4 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
            
            Button(action: {
                print("4")
                self.expand.toggle() //Expands the dropdown menu
                self.filledout = true //confirms that the form has been succesfully fieldout
                self.userSettings.activitylevel = 7 //Stores to device storage the activity level
                self.selected = "Daily exercise and physical job"
            }) {
                Text("Daily exercise and physical job")
                .padding()
                if selected == "Daily exercise and physical job" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)

        }
            
    }
    
    .padding()
    .background(Color("BackgroundColor"))
    .cornerRadius(10)
    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)

        .animation(.spring())
        .padding(.horizontal, 60)
        }
    }
}
