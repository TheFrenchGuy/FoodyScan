//
//  SettingsView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 13/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
     @Environment(\.presentationMode) var presentation
     @Environment(\.colorScheme) var colorScheme
     @ObservedObject var userSettings = UserSettings()
     @State var username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
    @State var newusername = ""
    
    @State var edituser: Bool = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            Text("Settings")
                .font(.title)
                .bold()
                .padding(20)
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        if self.colorScheme == .light {
                        LottieView(filename: "SettingsLottie", speed: 1, loop: .loop)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                            .padding(20)
                        }
                        if self.colorScheme == .dark {
                            LottieView(filename: "SettingsDarkLottie", speed: 1, loop: .loop)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                            .padding(20)
                        }
                    }.frame(width: UIScreen.main.bounds.width)
                    VStack {
                        Text("Below you will find personalistion settings")
                            .font(Font.custom("Dashing Unicorn", size: 20))
                            .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                            .lineLimit(nil)
                    }.padding(.leading, 10)
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("IDcard")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Edit username")
                                    .foregroundColor(.white)
                                    //.padding(5)
                                Image(systemName: "chevron.right")
                                    .frame(width:  UIScreen.main.bounds.width - 198 ,alignment: .trailing)
                                    .foregroundColor(.white)
                            }.padding(.leading, 10)
                             .padding(.top, 5)
                            Divider()
                            HStack {
                                Image("Scale")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Reset your daily intake")
                                    .foregroundColor(.white)
                                    //.padding(5)
                                Image(systemName: "chevron.right")
                                    .frame(width:  UIScreen.main.bounds.width - 260  ,alignment: .trailing)
                                    .foregroundColor(.white)
                            }.padding(.leading, 10)
                            .padding(.top, 5)
                            Divider()
                            HStack {
                                Image("Logout")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Log out")
                                    .foregroundColor(.white)
                                    .padding(5)
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 155 ,alignment: .trailing)
                                    .foregroundColor(.white)
                            }.padding(.leading, 10)
                            .padding(.bottom, 5)
                        }.frame(width: UIScreen.main.bounds.width - 20)
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                        
                        Text("Reset your daily intake if you have lost weight or entered a field incorrectly during setup")
                            .lineLimit(2)
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                            
                            .frame(width: UIScreen.main.bounds.width - 20)
                            .fixedSize(horizontal: false, vertical: true)
                            //.padding(.bottom, 10)
                        VStack(alignment: .leading) {
                            HStack {
                                Image("Info")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("About FoodyScan")
                                    .foregroundColor(.black)
                                    //.padding(5)
                                Image(systemName: "chevron.right")
                                    .frame(width:  UIScreen.main.bounds.width - 226 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.leading, 10)
                             .padding(.top, 5)
                            Divider()
                            HStack {
                                Image("Rating")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Rate FoodyScan")
                                    .foregroundColor(.black)
                                    //.padding(5)
                                Image(systemName: "chevron.right")
                                    .frame(width:  UIScreen.main.bounds.width - 215  ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.leading, 10)
                            .padding(.top, 5)

                            Divider()

                            HStack {
                                Image("News")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("What's new")
                                    .foregroundColor(.black)
                                  //  .padding(5)
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 178 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.leading, 10)
                            .padding(.bottom, 5)
                            
                            Divider()

                            HStack {
                                Image("Twitter")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text(" Follow me on Twitter")
                                    .foregroundColor(.black)
                                  //  .padding(5)
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 250 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.leading, 10)
                            .padding(.bottom, 5)
                        }.frame(width: UIScreen.main.bounds.width - 20)
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        
                        
                        VStack {
                            HStack {
                                Text("Request a new feature")
                                
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 220 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.bottom, 5)
                            
                            Divider()
                            
                            HStack {
                                Text("Donation")
                                
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 120 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }.padding(.bottom, 5)
                            
                            
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Report a problem")
                                Image(systemName: "chevron.right")
                                .frame(width:  UIScreen.main.bounds.width - 210 ,alignment: .trailing)
                                    .foregroundColor(.black)
                            }
                            
                            
                        }.frame(width: UIScreen.main.bounds.width - 20)
                            .padding(.vertical, 10)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        
                        Text("If you enjoy FoodyScan please consider rating it on the App Store and maybe making a donation (it would help)")
                        .lineLimit(2)
                        .font(.caption)
                        .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                        
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 20)
                        
                        
                        HStack {
                            Text("Reset User Data")
                        }.frame(width: UIScreen.main.bounds.width - 20)
                            .padding(.vertical, 10)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        
                    }.frame(width: UIScreen.main.bounds.width)
                }
            }
            
            
        }.onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("UserName"),object: nil, queue: .main) { (_) in
                self.username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
            }
        }
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.newusername, forKey: "UserName")
        print("username saved")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

