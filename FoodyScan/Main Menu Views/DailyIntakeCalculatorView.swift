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
    @State var show = false
    @ObservedObject var userSettings = UserSettings()
    @State var filledout = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            if self.show {
                BirthView(show: self.$show)
            } else {
            
            VStack(alignment: .leading) {
                GenderPicker()
                    .padding(.vertical, 20)
                
                
                Button(action: {
                    self.show.toggle()
                    
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
                
                DropDownActivity(filledout: self.$filledout)
                
            
                Button(action: {
                    print("success setup") //Debug Only
                    UserDefaults.standard.set(true, forKey: "setup") //The user has already previously logged in therefore he doesnt need to complete the DailyIntake Calculator
                    NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
                }) {
                    
                    if self.filledout == false {
                        Text("Please fill out the whole form")
                        .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.red)
                            .cornerRadius(10)
                        .padding(.top, 25)
                        .padding(.horizontal, 30)
                    } else {
                        HStack {
                            Text("Continue")
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
    @ObservedObject var userSettings = UserSettings()
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
                    Text(gender)
                }
            }
                
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.offWhite)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                .animation(.spring())
        }
    }
}

struct HeightWeightView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        VStack {
            VStack {
                Text("Please select your height")
                    .bold()
                Slider(value: $userSettings.height, in: 120...220, step: 0.5)
                    .accentColor(Color("Color"))
                Text("You are \(userSettings.height, specifier: "%g") cm")
            }
            
            .padding()
            
            VStack {
                Text("Please select your weight")
                    .bold()
                Slider(value: $userSettings.weight, in: 40...150, step: 0.5)
                    .accentColor(Color("Color"))
                Text("You weight \(userSettings.weight, specifier: "%g") kg")
            }
            .padding()
        }
    }
}

struct BirthView : View {
    
    @Binding var show:Bool
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @ObservedObject var userSettings = UserSettings()
    
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
                Text("Select your birthdate")
            }.labelsHidden()

            Text("Your birthdate is \(userSettings.birthdate, formatter: dateFormatter)")

        
            Button(action: {
                self.show.toggle()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
            .foregroundColor(Color("Color"))
            }.buttonStyle(SimpleButtonStyle())
        }
    }
}
struct DailyIntakeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeCalculatorView()
    }
}

struct DropDownActivity: View {
    @State var expand = false
    @State var selected = ""
    @Binding var filledout: Bool
    @ObservedObject var userSettings = UserSettings()
    
    
    var body: some View{
        VStack(alignment: .center) {
            VStack() {
            HStack(){
                Text( userSettings.activitylevel == "" ? "What your activity level? " : userSettings.activitylevel)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
            Image(systemName: expand ? "chevron.up" : "chevron.down")
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
                self.expand.toggle()
                self.filledout = true
                self.userSettings.activitylevel = "No or little exercise/sedentary"
            }) {
                Text("No or little exercise/sedentary")
                .padding()
                if selected == "No or little exercise/sedentary" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("2")
                self.expand.toggle()
                self.filledout = true
                self.userSettings.activitylevel = "Easy exercise (2-3 times/week)"
            }) {
                Text("Easy exercise (2-3 times/week)")
                .padding()
                if userSettings.activitylevel == "Easy exercise (2-3 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("3")
                self.expand.toggle()
                self.filledout = true
                self.userSettings.activitylevel = "Moderate exercise (4 times/week)"
            }) {
                Text("Moderate exercise (4 times/week)")
                .padding()
                if userSettings.activitylevel == "Moderate exercise (4 times/week)" {
                    Image(systemName: "checkmark")
                }
            }.foregroundColor(.black)
            
            Button(action: {
                print("4")
                self.expand.toggle()
                self.filledout = true
                self.userSettings.activitylevel = "Daily exercise and physical job"
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
