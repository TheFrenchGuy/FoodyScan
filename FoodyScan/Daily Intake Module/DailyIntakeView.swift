//
//  DailyIntakeView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 05/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct DailyIntakeView: View {
    var body: some View {
        PieView()
    }
}

//Pie Data
//let leftpercentage = ((UserSettings().dailyintakekcal - UserSettings().eatentoday) / UserSettings().dailyintakekcal) * 100
//let eatenpercentage = (UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100


struct Pie: Identifiable {
    var id: Int
    var percent: CGFloat
    var name: String
    var color: LinearGradient
}


struct PieView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userSettings = UserSettings()
    @Environment(\.presentationMode) var presentationMode
    let lefttoeat = UserSettings().dailyintakekcal - UserSettings().eatentoday
    let leftpercentage = ((UserSettings().dailyintakekcal - UserSettings().eatentoday) / UserSettings().dailyintakekcal) * 100
    let eatenpercentage = (UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100
    
    var data:Array<Pie> { return  [
        Pie(id: 0, percent: CGFloat(eatenpercentage), name: "Eaten", color: LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing)),
        Pie(id: 1, percent: CGFloat(leftpercentage), name: "Left", color: LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))
        ]}
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                
                //pie charts...
                    ZStack {
                        Text("Your daily calories energy charts")
                        .font(.system(size: 32, weight: .black))
                        .frame(width:360, height: 100)
                    }.padding(.top, 100)
                    
                    Divider()
                    
                    ZStack {
                        
                        GeometryReader{g in
                            
                            
                            ZStack {
                                ForEach(0..<self.data.count){i in
                                    DrawShape(data: self.data, center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                                    
                                }
                                
                                Circle()
                                    .frame(height:300)
                                    .foregroundColor(Color("BackgroundColor"))
                            }
                        }
                        .frame(height: 360)
                        .padding(.top, 20)
                        
                        //since it is in circle shape so where going to clip it in circle
                        .clipShape(Circle())
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        // since radius is 180 so circle size will be 360...
                    }.padding(.top, 20)
                
                    VStack {
                        ForEach(data) {i in
                            
                            HStack {
                                Text(i.name)
                                    .frame(width: 75)
                                
                                
                                //fixed width...
                                
                                GeometryReader {g in
                                    HStack {
                                        
                                        Spacer(minLength: 0)
                                        
                                        Rectangle()
                                            .fill(i.color)
                                            .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent), height: 10)
                                        
                                        
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
                    }.padding()
                }
                //Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                self.userSettings.eatentoday = UserDefaults.standard.value(forKey: "eatentoday") as? Double ?? 1.0
                self.userSettings.dailyintakekcal = UserDefaults.standard.value(forKey: "dailyintakekcal") as? Double ?? 1000.0
            }
            
        }
        .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) { //UI at the top of the screen
                HStack {
                    GradientImage(image: "chevron.left", size: 18, width: 20)
                        .padding(.top, 20)
                    GradientText(title: "Back", size: 16, width: 180)
                        .padding(.top, 10)
                }
        })
        .navigationBarTitle(Text("Your Daily Intake"))
        
        
    }
    
    
    func getWidth(width: CGFloat, value: CGFloat)->CGFloat{
        let temp = value / 200
        return temp * width
    }
}

struct DrawShape : View {
    
    
    var data: Array<Pie>
    var center : CGPoint
    var index: Int
    
    
    var body: some View {
        
        Path{ path in
            path.move(to: self.center)
            path.addArc(center: self.center, radius: 180, startAngle: .init(degrees: self.from()), endAngle: .init(degrees: self.to()), clockwise: false)
        }.fill(data[index].color)
    }
    
    //since anglis is continuouse so we need to calculate the angles before and with the current to get exact angle....
    
    func from()->Double {
        
        if index  == 0 {
            return 0
        } else {
            var temp: Double = 0
            
            for i in 0...index-1 {
                temp += Double(data[i].percent / 100) * 360
            }
            
            return temp
        }
    }
    
    func to()->Double {
        
        //converting percentage to angle ...
        
        var temp: Double = 0
        // because we need to current degree ...
        for i in 0...index {
            temp += Double(data[i].percent / 100) * 360
            
        }
        return temp
    }
}







struct DailyIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeView()
    }
}
