//
//  CardView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 18/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI


//This is for the horizontal scrollview of the Inofmration Daily View
//Each view is the a card

struct CalorieChartIntake: View { //Calorie Pie Chart
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var CaloriePieData: Array<Pie>
    var lefttoeat: Double
    var lefteatpercentage: Double
    var eatencalpercentage: Double
    var isOverCal: Bool
    var body: some View {
        GeometryReader { geometry in
        VStack {
            Text("Calories Consumed today")
                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                .bold()
            if self.isOverCal {
                GradientImageInv(image: "exclamationmark.triangle", size: 42, width: 60).padding(20)
                GradientTextInv(title: "You are over your daily calorie intake", size: 18, width: Int(UIScreen.main.bounds.width) - 80)
                    //.padding(.bottom, 20)
                
                Text("You are over by \(self.eatencalpercentage - 100, specifier: "%0.f")% if your daily calories")
                    .font(.caption)
            } else {
                ZStack {
                   
                    GeometryReader{g in
                        
                        
                        ZStack {
                            ForEach(0..<self.CaloriePieData.count){i in
                                DrawShape(data: self.CaloriePieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                
                            }
                            
                            Circle()
                                .frame(width: (UIScreen.main.bounds.width * 0.63),height: (UIScreen.main.bounds.height * 0.32))
                                .foregroundColor(Color("BackgroundColor"))
                            Text("You had \(self.eatencalpercentage, specifier: "%0.f")% of your daily calories")
                                .font(Font.custom("Dashing Unicorn", size: 16))
                        }
                    }
                    .frame(width: (UIScreen.main.bounds.width * 0.75), height: (UIScreen.main.bounds.height * 0.34))
                    
                    
                    //since it is in circle shape so where going to clip it in circle
                    .clipShape(Circle())
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    // since radius is 180 so circle size will be 360...
                }
            }
        }.frame(width: (UIScreen.main.bounds.width * 0.83), height: (UIScreen.main.bounds.height * 0.38))
        .background(Color("BackgroundColor"))
        .cornerRadius(12)
        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(.leading, 30)
        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
        }.frame(width: (UIScreen.main.bounds.width * 0.87), height: UIScreen.main.bounds.height * 0.46)
    }
}

struct CalorieDailyIntake: View { //Calorie intake Text Information
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var lefttoeat: Double
    var CaloriePieData: Array<Pie>
    var isOverCal: Bool
      
    var body: some View {
        GeometryReader { geometry in
        VStack {
                HStack {
                Color(self.colorScheme == .light ? .black: .white)
                .mask(Image("Energy")
                    .resizable())
                .frame(width: 40, height: 40)
                Text("Calories information:")
                }.padding(.top , 20)
            
            if self.isOverCal {
                ForEach(self.CaloriePieData) {i in
                    
                    HStack {
                        Text(i.nameOver)
                            .fontWeight(.bold)
                            .frame(width: 75)
                        
                        
                        //fixed width...
                        
                        GeometryReader {g in
                            HStack {
                                
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: CGFloat(i.percent / 100)), height: 10)
                                    .cornerRadius(6)
                                
                                
                                if i.name == "Eaten" {
                                    Text("\(self.userSettings.eatentoday, specifier: "%.0f") kcal")
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                                }
                                else {
                                    Text("\((self.userSettings.eatentoday -  self.userSettings.dailyintakekcal), specifier: "%.0f") kcal")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                }
            } else {
            
            ForEach(self.CaloriePieData) {i in
                    
                    HStack {
                        Text(i.name)
                            .fontWeight(.bold)
                            .frame(width: 75)
                        
                        
                        //fixed width...
                        
                        GeometryReader {g in
                            HStack {
                                
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: CGFloat(i.percent)), height: 10)
                                    .cornerRadius(6)
                                
                                
                                if i.name == "Eaten" {
                                    Text("\(self.userSettings.eatentoday, specifier: "%.0f") kcal")
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                                }
                                else {
                                    Text("\(self.lefttoeat, specifier: "%.0f") kcal")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                }
            }
            }.frame(width: (UIScreen.main.bounds.width * 0.83), height: (UIScreen.main.bounds.height * 0.38))
            .background(Color("BackgroundColor"))
            .cornerRadius(12)
            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(30)
            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
        }.frame(width: (UIScreen.main.bounds.width * 0.87), height: UIScreen.main.bounds.height * 0.46)
    }
    
    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{ //To get the width of the charts
        let temp = value / 200
        return temp * width
    }
}


struct SugarChartIntake: View { //Sugar Pie view
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var SugarPieData: Array<Pie>
    var leftsugar: Double
    var leftsugarpercentage: Double
    var eatensugarpercentage: Double
    var isOverSugar: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Sugar Consumed today")
                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                    .bold()
                
                if self.isOverSugar {
                    GradientImageSec(image: "exclamationmark.triangle", size: 42, width: 60).padding(20)
                    GradientTextSec(title: "You are over your daily sugar intake", size: 18, width: Int(UIScreen.main.bounds.width) - 80)
                        //.padding(.bottom, 20)
                    
                    Text("You are over by \(self.eatensugarpercentage - 110, specifier: "%0.f")% if your daily sugar intake")
                        .font(.caption)
                } else {
                    ZStack {
                       
                        GeometryReader{g in
                            
                            
                            ZStack {
                                ForEach(0..<self.SugarPieData.count){i in
                                    DrawShape(data: self.SugarPieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                    
                                }
                                
                                Circle()
                                    .frame(width: (UIScreen.main.bounds.width * 0.63),height: (UIScreen.main.bounds.height * 0.32))
                                    .foregroundColor(Color("BackgroundColor"))
                                
                                Text("You had \(self.eatensugarpercentage, specifier: "%0.f")% of your sugar intake")
                                .font(Font.custom("Dashing Unicorn", size: 16))
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width * 0.75), height: (UIScreen.main.bounds.height * 0.34))
                        
                        
                        //since it is in circle shape so where going to clip it in circle
                        .clipShape(Circle())
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        // since radius is 180 so circle size will be 360...
                    }
                }
            }.frame(width: (UIScreen.main.bounds.width * 0.83), height: (UIScreen.main.bounds.height * 0.38))
            .background(Color("BackgroundColor"))
            .cornerRadius(12)
            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(30)
             .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
        }.frame(width: (UIScreen.main.bounds.width * 0.87), height: UIScreen.main.bounds.height * 0.46)
    }
}

struct SugarDailyIntake: View { //Sugar information as a Text
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var SugarPieData: Array<Pie>
    var leftsugar: Double
    var leftsugarpercentage: Double
    var eatensugarpercentage: Double
    var isOverSugar: Bool
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Color(self.colorScheme == .light ? .black: .white)
                        .mask(Image("Sugar")
                            .resizable())
                        .frame(width: 40, height: 40)
                Text("Sugar Information:")
                }.padding(.top , 20)
                if self.isOverSugar {
                    ForEach(self.SugarPieData) {i in
                        
                        HStack {
                            Text(i.nameOver)
                                .fontWeight(.bold)
                                .frame(width: 75)
                                .padding(.leading, 10)
                            
                            
                            //fixed width...
                            
                            GeometryReader {g in
                                HStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    Rectangle()
                                        .fill(i.color)
                                        .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent / 10), height: 10)
                                        .cornerRadius(6)
                                    
                                    
                                    if i.name == "Sugar In" {
                                        Text("\(self.eatenToday.sugarToday, specifier: "%.0f") g")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                    }
                                    else {
                                        Text("\((self.eatenToday.sugarToday - 45), specifier: "%.0f") g")
                                            .fontWeight(.bold)
                                            .padding(.leading, 10)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }
                } else {
                    ForEach(self.SugarPieData) {i in
                        
                        HStack {
                            Text(i.name)
                                .fontWeight(.bold)
                                .frame(width: 75)
                                .padding(.leading, 10)
                            
                            
                            //fixed width...
                            
                            GeometryReader {g in
                                HStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    Rectangle()
                                        .fill(i.color)
                                        .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent), height: 10)
                                        .cornerRadius(6)
                                    
                                    
                                    if i.name == "Sugar In" {
                                        Text("\(self.eatenToday.sugarToday, specifier: "%.0f") g")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                    }
                                    else {
                                        Text("\(self.leftsugar, specifier: "%.0f") g")
                                            .fontWeight(.bold)
                                            .padding(.leading, 10)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }
                }
                }.frame(width: (UIScreen.main.bounds.width * 0.83), height: (UIScreen.main.bounds.height * 0.38))
                .background(Color("BackgroundColor"))
                .cornerRadius(12)
                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                .padding(30)
             .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
        }.frame(width: (UIScreen.main.bounds.width * 0.87), height: UIScreen.main.bounds.height * 0.46)
    }
    
    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{ //To get the width of the charts
        let temp = value / 200
        return temp * width
    }
    
}


struct CalorieChartIntakePad: View { //Calorie Pie Chart
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var CaloriePieData: Array<Pie>
    var lefttoeat: Double
    var lefteatpercentage: Double
    var eatencalpercentage: Double
    var isOverCal: Bool
    var body: some View {
    
        VStack {
            Text("Calories Consumed today")
                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                .bold()
            if self.isOverCal {
                GradientImageInv(image: "exclamationmark.triangle", size: 42, width: 60).padding(20)
                GradientTextInv(title: "You are over your daily calorie intake", size: 18, width: Int(UIScreen.main.bounds.width) - 80)
                    //.padding(.bottom, 20)
                
                Text("You are over by \(self.eatencalpercentage - 100, specifier: "%0.f")% if your daily calories")
                    .font(.caption)
            } else {
                ZStack {
                   
                    GeometryReader{g in
                        
                        
                        ZStack {
                            ForEach(0..<self.CaloriePieData.count){i in
                                DrawShape(data: self.CaloriePieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                
                            }
                            
                            Circle()
                                .frame(width: (UIScreen.main.bounds.width * 0.63),height: (UIScreen.main.bounds.height * 0.32))
                                .foregroundColor(Color("BackgroundColor"))
                            Text("You had \(self.eatencalpercentage, specifier: "%0.f")% of your daily calories")
                                .font(Font.custom("Dashing Unicorn", size: 16))
                        }
                    }
                    .frame(width: (UIScreen.main.bounds.width * 0.75), height: (UIScreen.main.bounds.height * 0.34))
                    
                    
                    //since it is in circle shape so where going to clip it in circle
                    .clipShape(Circle())
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    // since radius is 180 so circle size will be 360...
                }
            }
        }.frame(width: (UIScreen.main.bounds.width * 0.3), height: (UIScreen.main.bounds.height * 0.38))
        .background(Color("BackgroundColor"))
        .cornerRadius(12)
        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(.leading, 30)
        }
}

struct CalorieDailyIntakePad: View { //Calorie intake Text Information
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var lefttoeat: Double
    var CaloriePieData: Array<Pie>
    var isOverCal: Bool
      
    var body: some View {
        VStack {
                HStack {
                Color(self.colorScheme == .light ? .black: .white)
                .mask(Image("Energy")
                    .resizable())
                .frame(width: 40, height: 40)
                Text("Calories information:")
                }.padding(.top , 20)
            
            if self.isOverCal {
                ForEach(self.CaloriePieData) {i in
                    
                    HStack {
                        Text(i.nameOver)
                            .fontWeight(.bold)
                            .frame(width: 75)
                        
                        
                        //fixed width...
                        
                        GeometryReader {g in
                            HStack {
                                
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: CGFloat(i.percent / 100)), height: 10)
                                    .cornerRadius(6)
                                
                                
                                if i.name == "Eaten" {
                                    Text("\(self.userSettings.eatentoday, specifier: "%.0f") kcal")
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                                }
                                else {
                                    Text("\((self.userSettings.eatentoday -  self.userSettings.dailyintakekcal), specifier: "%.0f") kcal")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                }
            } else {
            
            ForEach(self.CaloriePieData) {i in
                    
                    HStack {
                        Text(i.name)
                            .fontWeight(.bold)
                            .frame(width: 75)
                        
                        
                        //fixed width...
                        
                        GeometryReader {g in
                            HStack {
                                
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: CGFloat(i.percent)), height: 10)
                                    .cornerRadius(6)
                                
                                
                                if i.name == "Eaten" {
                                    Text("\(self.userSettings.eatentoday, specifier: "%.0f") kcal")
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                                }
                                else {
                                    Text("\(self.lefttoeat, specifier: "%.0f") kcal")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                }
            }
            }.frame(width: (UIScreen.main.bounds.width * 0.3), height: (UIScreen.main.bounds.height * 0.38))
            .background(Color("BackgroundColor"))
            .cornerRadius(12)
            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(30)
    }
    
    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{ //To get the width of the charts
        let temp = value / 200
        return temp * width
    }
}

struct SugarChartIntakePad: View { //Sugar Pie view
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var SugarPieData: Array<Pie>
    var leftsugar: Double
    var leftsugarpercentage: Double
    var eatensugarpercentage: Double
    var isOverSugar: Bool
    
    var body: some View {
            VStack {
                Text("Sugar Consumed today")
                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                    .bold()
                
                if self.isOverSugar {
                    GradientImageSec(image: "exclamationmark.triangle", size: 42, width: 60).padding(20)
                    GradientTextSec(title: "You are over your daily sugar intake", size: 18, width: Int(UIScreen.main.bounds.width) - 80)
                        //.padding(.bottom, 20)
                    
                    Text("You are over by \(self.eatensugarpercentage - 110, specifier: "%0.f")% if your daily sugar intake")
                        .font(.caption)
                } else {
                    ZStack {
                       
                        GeometryReader{g in
                            
                            
                            ZStack {
                                ForEach(0..<self.SugarPieData.count){i in
                                    DrawShape(data: self.SugarPieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                    
                                }
                                
                                Circle()
                                    .frame(width: (UIScreen.main.bounds.width * 0.63),height: (UIScreen.main.bounds.height * 0.32))
                                    .foregroundColor(Color("BackgroundColor"))
                                
                                Text("You had \(self.eatensugarpercentage, specifier: "%0.f")% of your sugar intake")
                                .font(Font.custom("Dashing Unicorn", size: 16))
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width * 0.75), height: (UIScreen.main.bounds.height * 0.34))
                        
                        
                        //since it is in circle shape so where going to clip it in circle
                        .clipShape(Circle())
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        // since radius is 180 so circle size will be 360...
                    }
                }
            }.frame(width: (UIScreen.main.bounds.width * 0.3), height: (UIScreen.main.bounds.height * 0.38))
            .background(Color("BackgroundColor"))
            .cornerRadius(12)
            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            .padding(30)
//            .frame(width: (UIScreen.main.bounds.width * 0.87), height: UIScreen.main.bounds.height * 0.46)
    }
}

struct SugarDailyIntakePad: View { //Sugar information as a Text
    @Environment(\.colorScheme) var colorScheme //The colorscheme of the user device
    @ObservedObject var userSettings = UserSettings() //UserSettins Model
    @ObservedObject var eatenToday = EatenToday() //EatenTooday model
    var SugarPieData: Array<Pie>
    var leftsugar: Double
    var leftsugarpercentage: Double
    var eatensugarpercentage: Double
    var isOverSugar: Bool
    var body: some View {
            VStack {
                HStack {
                    Color(self.colorScheme == .light ? .black: .white)
                        .mask(Image("Sugar")
                            .resizable())
                        .frame(width: 40, height: 40)
                Text("Sugar Information:")
                }.padding(.top , 20)
                if self.isOverSugar {
                    ForEach(self.SugarPieData) {i in
                        
                        HStack {
                            Text(i.nameOver)
                                .fontWeight(.bold)
                                .frame(width: 75)
                                .padding(.leading, 10)
                            
                            
                            //fixed width...
                            
                            GeometryReader {g in
                                HStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    Rectangle()
                                        .fill(i.color)
                                        .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent / 10), height: 10)
                                        .cornerRadius(6)
                                    
                                    
                                    if i.name == "Sugar In" {
                                        Text("\(self.eatenToday.sugarToday, specifier: "%.0f") g")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                    }
                                    else {
                                        Text("\((self.eatenToday.sugarToday - 45), specifier: "%.0f") g")
                                            .fontWeight(.bold)
                                            .padding(.leading, 10)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }
                } else {
                    ForEach(self.SugarPieData) {i in
                        
                        HStack {
                            Text(i.name)
                                .fontWeight(.bold)
                                .frame(width: 75)
                                .padding(.leading, 10)
                            
                            
                            //fixed width...
                            
                            GeometryReader {g in
                                HStack {
                                    
                                    Spacer(minLength: 0)
                                    
                                    Rectangle()
                                        .fill(i.color)
                                        .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent), height: 10)
                                        .cornerRadius(6)
                                    
                                    
                                    if i.name == "Sugar In" {
                                        Text("\(self.eatenToday.sugarToday, specifier: "%.0f") g")
                                        .fontWeight(.bold)
                                        .padding(.leading, 10)
                                    }
                                    else {
                                        Text("\(self.leftsugar, specifier: "%.0f") g")
                                            .fontWeight(.bold)
                                            .padding(.leading, 10)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }
                }
                }.frame(width: (UIScreen.main.bounds.width * 0.3), height: (UIScreen.main.bounds.height * 0.38))
                .background(Color("BackgroundColor"))
                .cornerRadius(12)
                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                .padding(30)
             
    }
    
    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{ //To get the width of the charts
        let temp = value / 200
        return temp * width
    }
    
}
