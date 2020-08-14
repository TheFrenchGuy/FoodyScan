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
             Color("BackgroundColor").edgesIgnoringSafeArea(.all) //So that the background of the app is constant on all of the views
            
            VStack {
            HStack(alignment: .center) {
                Image("FoodyScanLargeIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                GradientText(title: "Foody Scan", size: 24, width: 165)
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
                
                TextField("Enter your name", text: self.$username) //Textfield to enter user usersname
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
                    if self.username == "" { //Cannot tap on the continue button if there is no username inputed
                        HStack {
                            Text("Enter a username")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            }
                        .frame(width: UIScreen.main.bounds.width - 60)
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                        .padding(.bottom, 25)
                    } else {
                        Button(action: {
                            self.saveUserName() //causes the username to be save
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
                            .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5.0)
                            .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                            .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                            .padding(.bottom, 25)
                        }.disabled(self.username == "") //Incase of it is blocked when there is no username saveed
                    }
                }.onTapGesture {
                    if self.username != "" {
                        self.saveUserName()// When he taps on the continue button it will also save the username
                    }
                }
            }
        }
        .navigationBarTitle("") //So that it doesnt show the navigation bar and also doesnt let the user go back
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.username, forKey: "UserName") //Stores the username to usersettings for persistant storage
        print("username saved")
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
