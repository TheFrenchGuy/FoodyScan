//
//  SettingsView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 13/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreHaptics
struct SettingsView: View {
     @Environment(\.presentationMode) var presentation
     @Environment(\.colorScheme) var colorScheme
     @ObservedObject var userSettings = UserSettings()
     @State var username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
     @State private var engine: CHHapticEngine?
     @State var newusername = ""
     @State var showSettings:Int = 1
     @State private var showEmailAlert: Bool = false
     @State private var showReportAlert: Bool = false
    
    @State var edituser: Bool = false
    var body: some View {
        
        
        NavigationView {
            ZStack {
                if self.showSettings == 1{
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
                                    
                                    if self.edituser == false {
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
                                            .onTapGesture {
                                                withAnimation(.linear) {
                                                    self.edituser = true
                                                }
                                        }
                                    } else {
                                        VStack {
                                            HStack {
                                                Image("IDcard")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                Text("Edit username")
                                                    .foregroundColor(.white)
                                                    //.padding(5)
                                                Image(systemName: "chevron.down")
                                                    .frame(width:  UIScreen.main.bounds.width - 198 ,alignment: .trailing)
                                                    .foregroundColor(.white)
                                                
                                                
                                            }.padding(.trailing, 2)
                                             .padding(.top, 5)
                                            .onTapGesture {
                                                withAnimation(.linear) {
                                                    self.edituser = false
                                                }
                                            }
                                            HStack {
                                                TextField("Enter new username", text: self.$newusername)
                                                
                                                Button(action: {
                                                        self.edituser = false
                                                        if self.newusername != "" {
                                                            self.complexSuccess()// Haptics so gives user feedback
                                                            self.saveUserName()
                                                        }
                                                }) {
                                                    if self.newusername != "" {
                                                    Image(systemName: "square.and.arrow.down")
                                                        //.padding(.vertical)
                                                        .frame(width:  UIScreen.main.bounds.width - 220 ,alignment: .trailing)
                                                        .foregroundColor(self.colorScheme == .light ? Color.black: Color.white)
                                                        .onAppear(perform: prepareHaptics)
                                                    }
                                                }

                                            }.frame(width: UIScreen.main.bounds.width - 50)
                                            .padding()
                                            .background(self.colorScheme == .light ? Color.white: Color.black)
                                            .cornerRadius(10)
                                            
                                        }
                                    }
                                    Divider()
                                        HStack {
                                            Image("Scale")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                            Text("Reset your daily intake")
                                                .foregroundColor(.white)
                                                //.padding(5)
                                            
                                            Button(action: {
                                                withAnimation(.linear) {
                                                    self.showSettings = 2
                                                    self.resetIntake()
                                                }
                                                
                                                
                                            }) {
                                                Image(systemName: "chevron.right")
                                                    .frame(width:  UIScreen.main.bounds.width - 260  ,alignment: .trailing)
                                                    .foregroundColor(.white)
                                            }
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
                                        
                                        Button(action: {
                                            try! Auth.auth().signOut()
                                            GIDSignIn.sharedInstance()?.signOut()
                                            UserDefaults.standard.set(false, forKey: "status")
                                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                            
                                            self.showSettings = 3
                                        }) {
                                            Image(systemName: "chevron.right")
                                            .frame(width:  UIScreen.main.bounds.width - 155 ,alignment: .trailing)
                                                .foregroundColor(.white)
                                        }
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
                                        
                                        NavigationLink(destination: Text("About me page")) {
                                            Image(systemName: "chevron.right")
                                                .frame(width:  UIScreen.main.bounds.width - 226 ,alignment: .trailing)
                                                .foregroundColor(.black)
                                        }
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
                                        
                                        NavigationLink(destination: Text("Ratings")) {
                                            Image(systemName: "chevron.right")
                                                .frame(width:  UIScreen.main.bounds.width - 215  ,alignment: .trailing)
                                                .foregroundColor(.black)
                                        }
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
                                        
                                        NavigationLink(destination: Text("What's new")) {
                                        Image(systemName: "chevron.right")
                                            .frame(width:  UIScreen.main.bounds.width - 178 ,alignment: .trailing)
                                                .foregroundColor(.black)
                                        }
                                    }.padding(.leading, 10)
                                    .padding(.bottom, 5)
                                    
                                    Divider()

                                    HStack {
                                        Image("Twitter")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text("Follow me on Twitter")
                                            .foregroundColor(.black)
                                          //  .padding(5)
                                        
                                        Button(action: {
                                            if let url = URL(string: "https://twitter.com/TheFrenchGuyFr") {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Image(systemName: "chevron.right")
                                            .frame(width:  UIScreen.main.bounds.width - 245 ,alignment: .trailing)
                                            .foregroundColor(.black)
                                        }
                                    }.padding(.leading, 10)
                                    .padding(.bottom, 5)
                                }.frame(width: UIScreen.main.bounds.width - 20)
                                .background(LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                .padding(.bottom, 20)
                                
                                
                                VStack {
                                    HStack {
                                        Text("Request a new feature")
                                        Button(action: {
                                            self.showEmailAlert = true
                                        }) {
                                        Image(systemName: "chevron.right")
                                        .frame(width:  UIScreen.main.bounds.width - 220 ,alignment: .trailing)
                                            .foregroundColor(.black)
                                        }.padding(.bottom, 5)
                                            .alert(isPresented: $showEmailAlert) {
                                                Alert(title: Text("FoodyScan Feedback"), message: Text("Please send an email to noedelacroix@protonmail.com"),primaryButton: .default(Text("Copy Email Address"), action: {
                                                    UIPasteboard.general.string = "noedelacroix@protonmail.com"
                                                }), secondaryButton: .default(Text("Okay")))
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Donation")
                                        
                                        Image(systemName: "chevron.right")
                                        .frame(width:  UIScreen.main.bounds.width - 120 ,alignment: .trailing)
                                            .foregroundColor(.black)
                                    }.padding(.bottom, 5)
                                    
                                    Divider()
                            
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("Report a problem")
                                        
                                        Button(action :{
                                            self.showReportAlert = true
                                        }) {
                                        Image(systemName: "chevron.right")
                                        .frame(width:  UIScreen.main.bounds.width - 210 ,alignment: .trailing)
                                            .foregroundColor(.black)
                                        }.alert(isPresented: $showReportAlert) {
                                                Alert(title: Text("Report Problem"), message: Text("Please send an email to noedelacroix@protonmail.com"),primaryButton: .default(Text("Copy Email Address"), action: {
                                                    UIPasteboard.general.string = "noedelacroix@protonmail.com"
                                                }), secondaryButton: .default(Text("Okay")))
                                        }
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
                                
                                Button(action: {
                                     self.presentation.wrappedValue.dismiss()
                                }){
                                HStack {
                                    Text("Reset User Data")
                                }.frame(width: UIScreen.main.bounds.width - 20)
                                    .padding(.vertical, 10)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(5.0)
                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                    .padding(.bottom, 30)
                                }
                            }.frame(width: UIScreen.main.bounds.width)
                        }
                    }
                    
                    
                }.onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("UserName"),object: nil, queue: .main) { (_) in
                        self.username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
                        }
                    }
                .frame(height: UIScreen.main.bounds.height)
                
                }
                if self.showSettings == 2{
                    ZStack {
                        Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                        VStack {
                            LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing)
                                .frame(width: UIScreen.main.bounds.width, height: 70)
                                .mask(Text("Drag down to reset your daily intake")
                                    .font(.system(size: 20, weight: .heavy))
                            )
                                .frame(width: UIScreen.main.bounds.width, alignment: .center)
                            .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, UIScreen.main.bounds.width - 350)
                            
                            if self.colorScheme == .light {
                            LottieView(filename: "DownArrowLightLottie", speed: 1, loop: .loop)
                                .frame(width: UIScreen.main.bounds.width * 0.3)
                            }
                            if self.colorScheme == .dark {
                                LottieView(filename: "DownArrowDarkLottie", speed: 1, loop: .loop)
                                .frame(width: UIScreen.main.bounds.width * 0.3)
                            }
                        }
                    }
                }
                
                if self.showSettings == 3{
                    ZStack {
                        Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                        VStack {
                            LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing)
                                .frame(width: UIScreen.main.bounds.width / 1.4, height: 70)
                                .mask(Text("Drag Down to return to welcome screen")
                                    .font(.system(size: 20, weight: .heavy))
                            )
                                .frame(width: UIScreen.main.bounds.width , alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, UIScreen.main.bounds.width - 340)
                            
                            if self.colorScheme == .light {
                            LottieView(filename: "DownArrowLightLottie", speed: 1, loop: .loop)
                                .frame(width: UIScreen.main.bounds.width * 0.3)
                            }
                            if self.colorScheme == .dark {
                                LottieView(filename: "DownArrowDarkLottie", speed: 1, loop: .loop)
                                .frame(width: UIScreen.main.bounds.width * 0.3)
                            }
                        }
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.newusername, forKey: "UserName")
        print("username saved")
    }
    
    func resetIntake() {
        UserDefaults.standard.set(true, forKey: "status") // So that the user wont have to re loggin at launch of the app again and forces him to home screen of the app
        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        
        UserDefaults.standard.set(false, forKey: "setup") // This means that the user is logging in the first time so he must complete the daily intake calculator
        NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
    }
    
    func prepareHaptics() {
               guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
                   print("Haptic not supported by device")
                   return
               }

               do {
                   self.engine = try CHHapticEngine()
                   try engine?.start()
               } catch {
                   print("There was an error creating the engine: \(error.localizedDescription)")
               }
           }
       
           func complexSuccess() {
               // make sure that the device supports haptics
               guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
               var events = [CHHapticEvent]()

               // create one intense, sharp tap
               let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
               let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
               let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
               events.append(event)

               // convert those events into a pattern and play it immediately
               do {
                   let pattern = try CHHapticPattern(events: events, parameters: [])
                   let player = try engine?.makePlayer(with: pattern)
                   try player?.start(atTime: 0)
               } catch {
                   print("Failed to play pattern: \(error.localizedDescription).")
               }
           }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

