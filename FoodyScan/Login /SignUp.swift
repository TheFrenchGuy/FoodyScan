//
//  SignUp.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SignUp : View {
    @Environment(\.colorScheme) var colorScheme
    @State var colorLight = Color.black.opacity(0.7)
    @State var colorDark = Color.white.opacity(0.7)
    @State var email = "" //Email of the new User
    @State var pass = "" //Password of the new user
    @State var repass = ""//Confirmation password of the new user
    @State var visible = false //If the password is visible
    @State var revisible = false // If confirmation password is visible
    @Binding var show : Bool
    @State var alert = false //Whever an error is active
    @State var error = "" //Error content
    
    var body: some View{
        
        ZStack{
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
//In order to make the background color to be offWhite
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        
                        Text("Sign Up")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.colorLight: self.colorDark)
                            .padding(.top, 35)
                        
//                        TextField("UserName", text: self.$username)
//                        .autocapitalization(.none)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
//                        .padding(.top, 25)

                        
                        TextField("Email", text: self.$email) //Email field
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.colorScheme == .light ? self.colorLight: self.colorDark,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                //If pressed it will changed between the password being visibile and hidden
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill") //If visible is active the password can be seen so icon matches, vice versa
                                    .foregroundColor(self.colorScheme == .light ? self.colorLight: self.colorDark)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.colorScheme == .light ? self.colorLight: self.colorDark,lineWidth: 2)) //When the user is onto the textField he will have feedback the he is currently inputting text into that textfield
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                //If pressed it will changed between the password being visibile and hidden
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")//If visible is active the password can be seen so icon matches, vice versa
                                    .foregroundColor(self.colorScheme == .light ? self.colorLight: self.colorDark)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.colorScheme == .light ? self.colorLight: self.colorDark,lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            
                            self.register() //Initiate the Register function
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                        .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                        .padding(.top, 25)
                        
                        
                        
                       
                        
                    }
                    .padding(.horizontal, 25)
                }
                
                Button(action: {
                    
                    self.show.toggle() //Switches the show variable to true to go back to main login screen
                    
                }) {
                    
                    GradientImage(image: "chevron.left", size: 20, width: 40)
                        
                }
                .padding()
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error) //Prints error onto the screen
            }
        }
        .navigationBarBackButtonHidden(true) //Allows the user to go backward
    }
    
    func register(){
        
        if self.email != ""{ //If the user has filled the email textfield
            //UserDefaults.standard.set(self.username, forKey: "UserName")
            UserDefaults.standard.set(self.email, forKey: "Email")
            if self.pass == self.repass{ //If the two password matches
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    //Creates a user to the firebase cloud service
                    if err != nil{ //If there is an error
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle() //Prints the erro to the screen
                        return
                    }
                    
                    print("success") //Debug only that the user has succesfully logged in
                    
                    UserDefaults.standard.set(true, forKey: "status") // So that the user wont have to re loggin at launch of the app again and forces him to home screen of the app
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                    UserDefaults.standard.set(false, forKey: "setup") // This means that the user is logging in the first time so he must complete the daily intake calculator
                    NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
                    
                }
            }
            else{
                
                self.error = "Password mismatch"
                self.alert.toggle() //Print the error
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle() //Print the error
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(show: .constant(true))
    }
}
