//
//  InformationDailyView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct InformationDailyView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var eatenToday = EatenToday()
    @Environment(\.presentationMode) var presentationMode
    
    let lefttoeat = UserSettings().dailyintakekcal - UserSettings().eatentoday
    let lefteatpercentage = ((UserSettings().dailyintakekcal - UserSettings().eatentoday) / UserSettings().dailyintakekcal) * 100
    let eatencalpercentage = (UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100
       
    var CaloriePieData:Array<Pie> { return  [
           Pie(id: 0, percent: CGFloat(eatencalpercentage), name: "Eaten", color: LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing)),
           Pie(id: 1, percent: CGFloat(lefteatpercentage), name: "Left", color: LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))
           ]}
    
    let leftsugar = 45 - EatenToday().sugarToday
    let leftsugarpercentage = ((45 - EatenToday().sugarToday) / 45) * 100
    let eatensugarpercentage = (EatenToday().sugarToday / 45) * 100
    
    var SugarPieData:Array<Pie> { return [
            Pie(id: 0, percent: CGFloat(eatensugarpercentage), name: "Sugar In", color: LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing)),
                      Pie(id: 1, percent: CGFloat(leftsugarpercentage), name: "Daily sugar left", color: LinearGradient(gradient: Gradient(colors: [.gradientSecondaryStart, .gradientSecondaryEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))
        ]}
    
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            if self.eatenToday.firstItemDay == true {
                GradientText(title: "No Scans done today", size: 28, width: 290)
            }
            else {
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            GradientText(title: "Today's Stats", size: 28, width: 190)
                                .font(.system(size: 32, weight: .black))
                                .padding(.bottom , 20)
                            
                            Text("Below you will find information about what you have consumed today")
                                .font(Font.custom("Dashing Unicorn", size: 20))
                                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                .lineLimit(nil)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                               // GeometryReader { geometry in
                                    HStack {
                                        GeometryReader { geometry in
                                        VStack {
                                            Text("Calories Consumed today")
                                                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                                .bold()

                                            ZStack {
                                               
                                                GeometryReader{g in
                                                    
                                                    
                                                    ZStack {
                                                        ForEach(0..<self.CaloriePieData.count){i in
                                                            DrawShape(data: self.CaloriePieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                                            
                                                        }
                                                        
                                                        Circle()
                                                            .frame(width: 210,height:210)
                                                            .foregroundColor(Color("BackgroundColor"))
                                                        Text("You had \(self.eatencalpercentage, specifier: "%0.f")% of your daily calories")
                                                            .font(Font.custom("Dashing Unicorn", size: 16))
                                                    }
                                                }
                                                .frame(width: 240, height: 240)
                                                
                                                
                                                //since it is in circle shape so where going to clip it in circle
                                                .clipShape(Circle())
                                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                                // since radius is 180 so circle size will be 360...
                                            }
                                        }.frame(width: 280, height: 280)
                                        .background(Color("BackgroundColor"))
                                        .cornerRadius(12)
                                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                            .padding(.leading, 30)
                                        .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
                                        }.frame(width: 300, height: 345)
                                    
                                        GeometryReader { geometry in
                                        VStack {
                                                HStack {
                                                Color(self.colorScheme == .light ? .black: .white)
                                                .mask(Image("Energy")
                                                    .resizable())
                                                .frame(width: 40, height: 40)
                                                Text("Calories information:")
                                                }.padding(.top , 20)
                                            
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
                                                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent), height: 10)
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
                                            }.frame(width: 280, height: 280)
                                            .background(Color("BackgroundColor"))
                                            .cornerRadius(12)
                                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                            .padding(30)
                                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
                                        }.frame(width: 300, height: 345)
                                        GeometryReader { geometry in
                                            VStack {
                                                Text("Sugar Consumed today")
                                                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                                    .bold()

                                                ZStack {
                                                   
                                                    GeometryReader{g in
                                                        
                                                        
                                                        ZStack {
                                                            ForEach(0..<self.SugarPieData.count){i in
                                                                DrawShape(data: self.SugarPieData, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                                                
                                                            }
                                                            
                                                            Circle()
                                                                .frame(width: 210,height:210)
                                                                .foregroundColor(Color("BackgroundColor"))
                                                            
                                                            Text("You had \(self.eatensugarpercentage, specifier: "%0.f")% of your sugar intake")
                                                            .font(Font.custom("Dashing Unicorn", size: 16))
                                                        }
                                                    }
                                                    .frame(width: 240, height: 240)
                                                    
                                                    
                                                    //since it is in circle shape so where going to clip it in circle
                                                    .clipShape(Circle())
                                                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                                    // since radius is 180 so circle size will be 360...
                                                }
                                            }.frame(width: 280, height: 280)
                                            .background(Color("BackgroundColor"))
                                            .cornerRadius(12)
                                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                            .padding(30)
                                             .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
                                        }.frame(width: 300, height: 345)
                                            
                                        GeometryReader { geometry in
                                            VStack {
                                                HStack {
                                                    Color(self.colorScheme == .light ? .black: .white)
                                                        .mask(Image("Sugar")
                                                            .resizable())
                                                        .frame(width: 40, height: 40)
                                                Text("Sugar Information:")
                                                }.padding(.top , 20)
                                                
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
                                                }.frame(width: 280, height: 280)
                                                .background(Color("BackgroundColor"))
                                                .cornerRadius(12)
                                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                                .padding(30)
                                             .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX - 40)) / -20), axis: (x: 10, y: 10, z: 0))
                                        }.frame(width: 320, height: 345)
                                                
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
                                        Text("Carb: \(eatenToday.carbohydratesToday    , specifier: "%g") g")
                                    }.padding(10)
                                    VStack {
                                        Color(self.colorScheme == .light ? .black: .white)
                                            .mask(Image("Sugar")
                                                .resizable())
                                            .frame(width: 40, height: 40)
                                        Text("Sugar: \(eatenToday.sugarToday, specifier: "%0.f") g")
                                    }
                                    .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                    .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                    .padding(10)
                                    VStack {
                                        Color(self.colorScheme == .light ? .black: .white)
                                            .mask(Image("Salt")
                                                .resizable())
                                            .frame(width: 40, height: 40)
                                        Text("Salt: \(eatenToday.saltToday, specifier: "%g") g")
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
                                        Text("Fat: \(eatenToday.fatToday, specifier: "%g") g")
                                    }
                                    .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                    .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                    .padding(10)
                                    VStack {
                                        Color(self.colorScheme == .light ? .black: .white)
                                            .mask(Image("Fiber")
                                                .resizable())
                                            .frame(width: 40, height: 40)
                                        Text("Fiber: \(eatenToday.fiberToday, specifier: "%g") g")
                                    }
                                    .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                    .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                    .padding(10)
                                    VStack {
                                        Color(self.colorScheme == .light ? .black: .white)
                                            .mask(Image("Protein")
                                                .resizable())
                                            .frame(width: 40, height: 40)
                                        Text("Protein: \(eatenToday.proteinToday, specifier: "%0.f") g")
                                    }
                                    .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                                    .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                                    .padding(10)
                                }
                            }.padding(.leading, UIScreen.main.bounds.width / 10)
                            
                            Spacer()
                            
                        }.padding(.top, 20)
                    }
                }
            }
        }//.edgesIgnoringSafeArea(.top)
        .onAppear {
            self.userSettings.eatentoday = UserDefaults.standard.value(forKey: "eatentoday") as? Double ?? 1.0
            self.userSettings.dailyintakekcal = UserDefaults.standard.value(forKey: "dailyintakekcal") as? Double ?? 1000.0
            self.eatenToday.sugarToday = UserDefaults.standard.value(forKey: "sugarToday") as? Double ?? 1.0
        }
        
    }

    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{
           let temp = value / 200
           return temp * width
       }
}


struct InformationDailyView_Previews: PreviewProvider {
    static var previews: some View {
        InformationDailyView()
    }
}
