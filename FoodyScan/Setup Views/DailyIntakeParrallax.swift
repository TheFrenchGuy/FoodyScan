//
//  DailyIntakeParrallax.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 25/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct DailyIntakeParrallax: View {
    
    @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user has setup the account links back to the sign up screen
    
    @ObservedObject var userSettings = UserSettings()
    
    @State var done = false
    
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark])
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                if self.done == true { //Neccessary in order to store the data to memory also gives feedback to the user
                    DoneSetupView()
                        .padding(.top, 50)
                }
                else {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                ScrollView { //Where the headline and the content text will be stored
                    GeometryReader { geometry in //reads out the dimensions of the scroll view and keep track of the current scroll view position
                        ZStack {
                            if geometry.frame(in: .global).minY <= 0 { //Needed for the parallax effect while scrolling downward so only if the minY of our GeometryReader is negative or zero .
                                Image("TopViewFood")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: geometry.frame(in: .global).minY/9)
                                .clipped()
                            } else {
                                Image("TopViewFood")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill) //Necessary as we need to fill all of the top screen area more clean
                                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY) //Makes the image stretchy when you scroll up
                                    .clipped()
                                    .offset(y: -geometry.frame(in: .global).minY)
                            }
                        }
                    }
                    .frame(height: bounds.size.height / 2.5)
                    VStack(alignment: .leading) {
                        
                        HStack() {
                            Image("LogoLogin")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                            VStack(alignment: .leading) {
                                Text("Please continue to setup your account")
                                    .font(.custom("AvenirNext-Regular", size: 15))
                                    .padding(.horizontal, 20)
                                    .foregroundColor(.gray)
                                GradientText(title: "Foody Scan", size: 12, width: 80)
                                    .font(.custom("AvenirNext-Demibold", size: 15))
                                    .padding(.horizontal, 20)
                            }
                        }
                            .padding(.top, 20)
                        
                        LinearGradient(gradient: self.colors,startPoint: .leading, endPoint: .trailing)
                            .frame(width: 300, height: 80)
                            .mask(Text("Please enter your information")
                                .font(.custom("AvenirNext-Bold", size: 28))
                                .lineLimit(nil)
                        )
                            
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        Text("We need these to calculate your personal daily intake")
                            .font(.custom("AvenirNext-Regular", size: 15))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        DailyIntakeCalculatorView(done: self.$done).frame(width: bounds.size.width)
                            .padding(5)
                    }
                    
                    .frame(width: bounds.size.height / 2)
                    
                        }
                    }
                }
                    .navigationBarHidden(false)
            .edgesIgnoringSafeArea(.top)
        }
                
    }
}

struct DailyIntakeParrallax_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeParrallax()
    }
}
