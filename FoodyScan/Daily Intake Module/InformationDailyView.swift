//
//  InformationDailyView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI


struct InformationDailyView: View {
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    @Environment(\.presentationMode) var presentationMode //So the user can go back to the main screen
    
    let lefttoeat = UserSettings().dailyintakekcal - UserSettings().eatentoday //How much calories are left form the user daily intkae
    let lefteatpercentage = ((UserSettings().dailyintakekcal - UserSettings().eatentoday) / UserSettings().dailyintakekcal) * 100 //What percentage that makes up
    let eatencalpercentage = (UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100
       //What percentage of his dialy intake he has eaten
    var CaloriePieData:Array<Pie> { return  [
        Pie(id: 0, percent: CGFloat(eatencalpercentage), name: "Eaten", color: LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing), nameOver: "Eaten"),
        Pie(id: 1, percent: CGFloat(lefteatpercentage), name: "Left", color: LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing), nameOver: "Overby")
           ]} //So can be used to draw the pie charts throughout the app

    let leftsugar = 45 - EatenToday().sugarToday //How much sugar the user should eaten for the remaining of the day
    let leftsugarpercentage = ((45 - EatenToday().sugarToday) / 45) * 100 //What percentage that makes up
    let eatensugarpercentage = (EatenToday().sugarToday / 45) * 100 //What percentage has he eaten so far
    
    var SugarPieData:Array<Pie> { return [
        Pie(id: 0, percent: CGFloat(eatensugarpercentage), name: "Sugar In", color: LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing), nameOver: "Sugar In"),
        Pie(id: 1, percent: CGFloat(leftsugarpercentage), name: "Daily sugar left", color: LinearGradient(gradient: Gradient(colors: [.gradientSecondaryStart, .gradientSecondaryEnd]), startPoint: .topLeading, endPoint: .bottomTrailing), nameOver: "Excess of")
        ]} //So can eb used to draw the pie charts throughout the app
    
    var isOverCal: Bool {
        let lefttoeat = UserSettings().dailyintakekcal - UserSettings().eatentoday //How much calories are left form the user daily intkae
        if lefttoeat <= 0 {
            return true
        } else {
            return false
        }
    }
    
    var isOverSugar: Bool {
        let leftsugar = 45 - EatenToday().sugarToday //How much sugar the user should eaten for the remaining of the day
        
        if leftsugar <= 0 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                
                if self.eatenToday.firstItemDay == true { //If there is no scan for the day then don't show the Information View
                    VStack {
                        LottieView(filename: "GirlPlayingGuitarLottie", speed: 1, loop: .loop).frame(height: 240)
                        GradientText(title: "No Scans done today", size: 28, width: 290) //Feedback to the user
                    }
                }
                else {
                    ZStack(alignment: .topLeading) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ShapeView().offset(x: -60, y : -210).shadow(radius: 12)
                                GradientText(title: "Today's Stats", size: 28, width: 190)
                                    .font(.system(size: 32, weight: .black))
                                    .padding(.bottom , 20)
                                
                                Text("Below you will find information about what you have consumed today")
                                    .font(Font.custom("Dashing Unicorn", size: 20)) //Imported a custom font can be seen in the extension folder
                                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(nil) //So can wrap arround the screen
                                
                                ScrollView(.horizontal, showsIndicators: false) { //So that on all iphone device the view looks great and so more information can be seen
                                   // GeometryReader { geometry in
                                    
                                    if UIDevice.current.userInterfaceIdiom == .phone {
                                        HStack {
                                            
                                            CalorieChartIntake(CaloriePieData: self.CaloriePieData, lefttoeat: self.lefttoeat, lefteatpercentage: self.lefteatpercentage, eatencalpercentage: self.eatencalpercentage, isOverCal: self.isOverCal)
                                            
                                            CalorieDailyIntake(lefttoeat: self.lefttoeat, CaloriePieData: self.CaloriePieData, isOverCal: self.isOverCal)
                                            
                                            
                                            SugarChartIntake(SugarPieData: self.SugarPieData, leftsugar: self.leftsugar, leftsugarpercentage: self.leftsugarpercentage, eatensugarpercentage: self.eatensugarpercentage, isOverSugar: self.isOverSugar)
                                                
                                            SugarDailyIntake(SugarPieData: self.SugarPieData, leftsugar: self.leftsugar, leftsugarpercentage: self.leftsugarpercentage, eatensugarpercentage: self.eatensugarpercentage, isOverSugar: self.isOverSugar)
                                                    
                                        }
                                    } else {
                                        HStack {
                                            
                                            CalorieChartIntakePad(CaloriePieData: self.CaloriePieData, lefttoeat: self.lefttoeat, lefteatpercentage: self.lefteatpercentage, eatencalpercentage: self.eatencalpercentage, isOverCal: self.isOverCal)
                                            
                                            CalorieDailyIntakePad(lefttoeat: self.lefttoeat, CaloriePieData: self.CaloriePieData, isOverCal: self.isOverCal)
                                            
                                            
                                            SugarChartIntakePad(SugarPieData: self.SugarPieData, leftsugar: self.leftsugar, leftsugarpercentage: self.leftsugarpercentage, eatensugarpercentage: self.eatensugarpercentage, isOverSugar: self.isOverSugar)
                                                
                                            SugarDailyIntakePad (SugarPieData: self.SugarPieData, leftsugar: self.leftsugar, leftsugarpercentage: self.leftsugarpercentage, eatensugarpercentage: self.eatensugarpercentage, isOverSugar: self.isOverSugar)
                                                    
                                        }
                                    }
                                
                                   // }.frame(width: 280, height: 345)
                                }
                                
                                VStack{
                                    Text("You have consumed:")
                                        .font(Font.custom("Dashing Unicorn", size: 20))
                                    HStack {
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Carbohydrates")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Carb: \(self.eatenToday.carbohydratesToday, specifier: "%0.f") g")
                                        }.padding(10)
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Sugar")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Sugar: \(self.eatenToday.sugarToday, specifier: "%0.f") g")
                                        }
                                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                        .padding(10)
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Salt")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Salt: \(self.eatenToday.saltToday, specifier: "%0.f") g")
                                        }
                                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                        .padding(10)
                                        
                                    }
                                    HStack {
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Fat")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Fat: \(self.eatenToday.fatToday, specifier: "%0.f") g")
                                        }
                                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                        .padding(10)
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Fiber")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Fiber: \(self.eatenToday.fiberToday, specifier: "%0.f") g")
                                        }
                                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                        .padding(10)
                                        VStack {
                                            Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Protein")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                            Text("Protein: \(self.eatenToday.proteinToday, specifier: "%0.f") g")
                                        }
                                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                        .padding(10)
                                    }
                                }.frame(width: bounds.size.width, alignment: .center)
                                    .padding(.bottom, 60)
                                //.padding(.leading, bounds.size.width - 350)
                                
                                Spacer()
                                
                            }.padding(.top, 20)
                        }
                    }
                }
            }
        }//.edgesIgnoringSafeArea(.top)
        .onAppear {
            self.userSettings.eatentoday = UserDefaults.standard.value(forKey: "eatentoday") as? Double ?? 0.0 //Looks for changes to these variables
            self.userSettings.dailyintakekcal = UserDefaults.standard.value(forKey: "dailyintakekcal") as? Double ?? 1000.0
            self.eatenToday.sugarToday = UserDefaults.standard.value(forKey: "sugarToday") as? Double ?? 0.0
        }
        
    }

    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{ //To get the width of the charts
           let temp = value / 200
           return temp * width
       }
}


struct InformationDailyView_Previews: PreviewProvider {
    static var previews: some View {
        InformationDailyView()
    }
}


