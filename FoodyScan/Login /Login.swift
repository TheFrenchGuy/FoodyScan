//
//  Login.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct Login : View {
    @Environment(\.colorScheme) var colorScheme
    @State var colorLight = Color.black.opacity(0.7)
    @State var colorDark = Color.white.opacity(0.7)
    @State var email = "" //email of the user
    @State var pass = ""  //Password of the user
    @State var visible = false //Whever the user can see the password he types
    @Binding var show : Bool //Passed from the previous view
    @State var alert = false //Passed to error view
    @State var error = "" //Passed to error view
    
    var body: some View{
        
        ZStack{
           Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            ZStack(alignment: .topTrailing) {
               
               
                
                GeometryReader{_ in //defines content as a function of its own size and coordinate space.
                    
                    VStack{
                       
                       Image("LogoLogin") //Finger Print Icon
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130, height: 130)
                           .padding(.top, 30)
                           
                       
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.colorLight: self.colorDark )
                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8,y: 8)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email) //Input the email address
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.colorScheme == .light ? self.colorLight: self.colorDark,lineWidth: 2))
                        .padding(.top, 25)
                       
                       

                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass) //Shows the password inputed clearly
                                    .autocapitalization(.none)
                                   
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass) //Hides the password inputed
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle() //Flips between the visible state of the password
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill") //Changes the eye icon based on weather visibile is true or false to match password visible state
                                    .foregroundColor(self.colorScheme == .light ? self.colorLight: self.colorDark)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.colorScheme == .light ? self.colorLight: self.colorDark,lineWidth: 2))//When input the border of the text from changes color based on the Main Color of the app
                        .padding(.top, 25)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset() //Initiate the reset function
                                
                            }) {
                                
                                GradientText(title:"Forgot password", size: 17, width: 150 )
                                    .foregroundColor(Color("Color"))
                                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)

                            }
                        }
                            
                        .padding(.top, 10)
                       
                        
                        Button(action: {
                            
                            self.verify() //Initiate the verify function
                            
                        }) {
                            
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)

                        .padding(.top, 25)
                        
                       GoogleLoginView().frame(width: 150, height: 55)
                       .shadow(color: Color("LightShadow"), radius: 5, x: -5, y: -5)
                       .shadow(color: Color("DarkShadow"), radius: 5, x: 5, y: 5)
                    }
                    .padding(.horizontal, 25)
                    
                }
               
              
               
              
           
                Button(action: {
                    
                    self.show.toggle() //Makes true the show variable which should change view
                    
                }) {
                    
                    GradientText(title: "Register", size: 20, width: 90)
                }
                .padding()
                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error) //Prints an alert if an error has been encounter while login with error
            }
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{ //If the email and password are not empty then
            UserDefaults.standard.set(self.email, forKey: "email")
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                //Sends a request to Firebase database to check the login with what is in the cloud
                if err != nil{
                    
                    self.error = err!.localizedDescription //Will later print the error
                    self.alert.toggle()
                    return
                }
                
                print("success") //Debug Only
                UserDefaults.standard.set(true, forKey: "status") //Sets the status to be true and stored in memory so next app launch the user wont have to login
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                UserDefaults.standard.set(true, forKey: "setup") //The user has already previously logged in therefore he doesnt need to complete the DailyIntake Calculator
                NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle() //Causes the error view to trigger
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in //Causes an email with password link to be sent to the user
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET" //Refers to the Error view
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty" // if the email is empty
            self.alert.toggle()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(show: .constant(true))
    }
}

struct Login_Previews2: PreviewProvider {
    static var previews: some View {
        Login(show: .constant(true)).colorScheme(.dark)
    }
}
