//
//  NameView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 09/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct NameView: View {
    @State var username = "" //UserName of the user
    @State var loginpage = false
    var body: some View {
        ZStack {
             Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            
            VStack {
            HStack(alignment: .center) {
                Image("FoodyScanLargeIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                Text("Foody Scan")
                .foregroundColor(Color("Color"))
                    .font(.system(size: 24, weight: .heavy))
            }.padding(.bottom, 50)
             .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Please enter your name")
                    .font(.system(size: 36))
                    .font(.headline)
                    .bold()
                    .padding(.trailing, 60)
                }
                VStack {
                
                TextField("Enter your name", text: self.$username)
                .autocapitalization(.none)
                .padding()
                .background(Color("BackgroundColor"))
                .cornerRadius(5.0)
                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                .frame(width: UIScreen.main.bounds.width - 60)
                Spacer()
                }
                
                VStack(alignment: .center) {
                    NavigationLink(destination: LoginSignUpView(), isActive: $loginpage) {EmptyView()}
                    if self.username == "" {
                        HStack {
                            Text("Enter a username 🔥 ")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            }
                        .frame(width: UIScreen.main.bounds.width - 60)
                        .background(Color.red)
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                        .padding(.bottom, 25)
                    } else {
                        Button(action: {
                            self.saveUserName()
                            self.loginpage.toggle()
                        }) {
                            HStack {
                                Text("Login")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                Image(systemName: "chevron.right").foregroundColor(.white)
                                .padding(.vertical)
                                }
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .background(Color("Color"))
                            .cornerRadius(5.0)
                            .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                            .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                            .padding(.bottom, 25)
                        }.disabled(self.username == "")
                    }
                }.onTapGesture {
                    if self.username != "" {
                        self.saveUserName()
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.username, forKey: "UserName")
        print("username saved")
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
