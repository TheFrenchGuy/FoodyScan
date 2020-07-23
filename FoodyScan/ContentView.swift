//
//  ContentView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
 
 struct ContentView: View {
     var body: some View {
         
         Home()
     }
 }
 
 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 
 struct Home : View {
     
     @State var show = false
     @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
     
     var body: some View{
         
         NavigationView{
             
             VStack{
                 
                 if self.status{
                     
                     HomeScreenView()
                 }
                 else{
                     
                     ZStack{
                         
                         NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                             
                             Text("")
                         }
                         .hidden()
                         
                         Login(show: self.$show)
                     }
                 }
             }
             .navigationBarTitle("")
             .navigationBarHidden(true)
             .navigationBarBackButtonHidden(true)
             .onAppear {
                 
                 NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                     
                     self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                 }
             }
         }
     }
 }
 
 
 struct Login : View {
     
     @State var color = Color.black.opacity(0.7)
     @State var email = ""
     @State var pass = ""
     @State var visible = false
     @Binding var show : Bool
     @State var alert = false
     @State var error = ""
     
     var body: some View{
         
         ZStack{
             
             ZStack(alignment: .topTrailing) {
                 
                 GeometryReader{_ in
                     
                     VStack{
                        
                         Text("Log in to your account")
                             .font(.title)
                             .fontWeight(.bold)
                             .foregroundColor(self.color)
                             .padding(.top, 35)
                         
                         TextField("Email", text: self.$email)
                         .autocapitalization(.none)
                         .padding()
                         .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
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
                                 
                                 self.visible.toggle()
                                 
                             }) {
                                 
                                 Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                     .foregroundColor(self.color)
                             }
                             
                         }
                         .padding()
                         .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                         .padding(.top, 25)
                         
                         HStack{
                             
                             Spacer()
                             
                             Button(action: {
                                 
                                 self.reset()
                                 
                             }) {
                                 
                                 Text("Forget password")
                                     .fontWeight(.bold)
                                     .foregroundColor(Color("Color"))
                             }
                         }
                         .padding(.top, 20)
                        
                         
                         Button(action: {
                             
                             self.verify()
                             
                         }) {
                             
                             Text("Log in")
                                 .foregroundColor(.white)
                                 .padding(.vertical)
                                 .frame(width: UIScreen.main.bounds.width - 50)
                         }
                         .background(Color("Color"))
                         .cornerRadius(10)
                         .padding(.top, 25)
                         
                        
                        GoogleLoginView().frame(width: 150, height: 55)
                     }
                     .padding(.horizontal, 25)
                    
                     
                 }
                
               
                
               
                 
                 Button(action: {
                     
                     self.show.toggle()
                     
                 }) {
                     
                     Text("Register")
                         .fontWeight(.bold)
                         .foregroundColor(Color("Color"))
                 }
                 .padding()
             }
             
             if self.alert{
                 
                 ErrorView(alert: self.$alert, error: self.$error)
             }
         }
     }
     
     func verify(){
         
         if self.email != "" && self.pass != ""{
             
             Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
             
                 if err != nil{
                     
                     self.error = err!.localizedDescription
                     self.alert.toggle()
                     return
                 }
                 
                 print("success")
                 UserDefaults.standard.set(true, forKey: "status")
                 NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
             }
         }
         else{
             
             self.error = "Please fill all the contents properly"
             self.alert.toggle()
         }
     }
     
     func reset(){
         
         if self.email != ""{
             
             Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                 
                 if err != nil{
                     
                     self.error = err!.localizedDescription
                     self.alert.toggle()
                     return
                 }
                 
                 self.error = "RESET"
                 self.alert.toggle()
             }
         }
         else{
             
             self.error = "Email Id is empty"
             self.alert.toggle()
         }
     }
 }
 
 struct SignUp : View {
     
     @State var color = Color.black.opacity(0.7)
     @State var email = ""
     @State var pass = ""
     @State var repass = ""
     @State var visible = false
     @State var revisible = false
     @Binding var show : Bool
     @State var alert = false
     @State var error = ""
     
     var body: some View{
         
         ZStack{
             
             ZStack(alignment: .topLeading) {
                 
                 GeometryReader{_ in
                     
                     VStack{
                         
                         
                         Text("Log in to your account")
                             .font(.title)
                             .fontWeight(.bold)
                             .foregroundColor(self.color)
                             .padding(.top, 35)
                         
                         TextField("Email", text: self.$email)
                         .autocapitalization(.none)
                         .padding()
                         .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
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
                                 
                                 self.visible.toggle()
                                 
                             }) {
                                 
                                 Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                     .foregroundColor(self.color)
                             }
                             
                         }
                         .padding()
                         .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
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
                                 
                                 self.revisible.toggle()
                                 
                             }) {
                                 
                                 Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                     .foregroundColor(self.color)
                             }
                             
                         }
                         .padding()
                         .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.color,lineWidth: 2))
                         .padding(.top, 25)
                         
                         Button(action: {
                             
                             self.register()
                         }) {
                             
                             Text("Register")
                                 .foregroundColor(.white)
                                 .padding(.vertical)
                                 .frame(width: UIScreen.main.bounds.width - 50)
                         }
                         .background(Color("Color"))
                         .cornerRadius(10)
                         .padding(.top, 25)
                         
                     }
                     .padding(.horizontal, 25)
                 }
                 
                 Button(action: {
                     
                     self.show.toggle()
                     
                 }) {
                     
                     Image(systemName: "chevron.left")
                         .font(.title)
                         .foregroundColor(Color("Color"))
                 }
                 .padding()
             }
             
             if self.alert{
                 
                 ErrorView(alert: self.$alert, error: self.$error)
             }
         }
         .navigationBarBackButtonHidden(true)
     }
     
     func register(){
         
         if self.email != ""{
             
             if self.pass == self.repass{
                 
                 Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                     
                     if err != nil{
                         
                         self.error = err!.localizedDescription
                         self.alert.toggle()
                         return
                     }
                     
                     print("success")
                     
                     UserDefaults.standard.set(true, forKey: "status")
                     NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                 }
             }
             else{
                 
                 self.error = "Password mismatch"
                 self.alert.toggle()
             }
         }
         else{
             
             self.error = "Please fill all the contents properly"
             self.alert.toggle()
         }
     }
 }
 
 
 struct ErrorView : View {
     
     @State var color = Color.black.opacity(0.7)
     @Binding var alert : Bool
     @Binding var error : String
     
     var body: some View{
         
         GeometryReader{_ in
             
             VStack{
                 
                 HStack{
                     
                     Text(self.error == "RESET" ? "Message" : "Error")
                         .font(.title)
                         .fontWeight(.bold)
                         .foregroundColor(self.color)
                     
                     Spacer()
                 }
                 .padding(.horizontal, 25)
                 
                 Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                 .foregroundColor(self.color)
                 .padding(.top)
                 .padding(.horizontal, 25)
                 
                 Button(action: {
                     
                     self.alert.toggle()
                     
                 }) {
                     
                     Text(self.error == "RESET" ? "Ok" : "Cancel")
                         .foregroundColor(.white)
                         .padding(.vertical)
                         .frame(width: UIScreen.main.bounds.width - 120)
                 }
                 .background(Color("Color"))
                 .cornerRadius(10)
                 .padding(.top, 25)
                 
             }
             .padding(.vertical, 25)
             .frame(width: UIScreen.main.bounds.width - 70)
             .background(Color.white)
             .cornerRadius(15)
         }
         .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
     }
 }

struct GoogleLoginView: UIViewRepresentable {
    
    func makeCoordinator() -> GoogleLoginView.Coordinator {
        return GoogleLoginView.Coordinator()
    }
    
    class Coordinator: NSObject, GIDSignInDelegate {
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
          if let error = error {
            print(error.localizedDescription)
            return
          }

          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
              print(error.localizedDescription)
              return
            }
            print("signIn result: " + authResult!.user.email!)
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
          }
            
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<GoogleLoginView>) -> GIDSignInButton {
        let view = GIDSignInButton()
        GIDSignIn.sharedInstance().delegate = context.coordinator
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return view
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleLoginView>) { }
}


  
                 
