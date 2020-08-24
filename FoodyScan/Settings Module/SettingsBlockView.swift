//
//  SettingsBlockView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 14/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreHaptics
struct SettingsBlockView : View{
        @Environment(\.presentationMode) var presentation
        @Environment(\.colorScheme) var colorScheme
        @ObservedObject var userSettings = UserSettings()
        @State var username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
        @State private var engine: CHHapticEngine?
        @State var newusername = ""
        @Binding var showSettings:Int
        @State private var showEmailAlert: Bool = false
        @State private var showReportAlert: Bool = false
       
       @State var edituser: Bool = false
    var body: some View {
        GeometryReader { bounds in
            ZStack(alignment: .topLeading) {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Sets the background of the view (constant on all the views of the app)
                
                Text("Settings") //(Reminded to the user the view that just has loaded)
                .font(.title)
                .bold()
                .padding(.leading, 20)
                
                ScrollView(.vertical, showsIndicators: false) { //Used so on smaller iphone screen it is easily readable
                    
                    VStack(alignment: .leading) {
                        
                        
                        VStack {
                            if self.colorScheme == .light { //Depending on the usert selected theme it will display the animation but with the color reversed
                            LottieView(filename: "SettingsLottie", speed: 1, loop: .loop)
                                .frame(width: bounds.size.width * 0.45, height: bounds.size.width * 0.45) //Used to restrict the animation size
                                .padding(20)
                            }
                            if self.colorScheme == .dark { //Depending on the usert selected theme it will display the animation but with the color reversed
                                LottieView(filename: "SettingsDarkLottie", speed: 1, loop: .loop)
                                .frame(width: bounds.size.width * 0.45, height: bounds.size.width * 0.45) //Used to restrict the animation size
                                .padding(20)
                            }
                        }.frame(width: bounds.size.width) //So uses the full width of the screen and also is centered on the view
                        VStack {
                            Text("Foody Scans")
                                .font(Font.custom("Dashing Unicorn", size: 20))
                                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark) //Changes the font color depending on the colorscheme
                                .lineLimit(nil)
                        }.padding(.leading, 10)
                        
                        VStack {
                            VStack(alignment: .leading) {
                                
                                if self.edituser == false { //whever the user is editing his username
                                    HStack {
                                        Image("IDcard")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text("Edit username")
                                            .foregroundColor(.white)
                                            //.padding(5)
                                        Image(systemName: "chevron.right")
                                            .frame(width:  bounds.size.width - 198 ,alignment: .trailing)
                                            .foregroundColor(.white)
                                    }.padding(.leading, 10)
                                     .padding(.top, 5)
                                        .onTapGesture {
                                            withAnimation(.linear) { //Provides an animation so it looks smoother when transitioning
                                                self.edituser = true
                                            }
                                    }
                                } else { //When the user is editing his username
                                    VStack {
                                        HStack { //First HStack is the same as the top code
                                            Image("IDcard")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                            Text("Edit username")
                                                .foregroundColor(.white)
                                                //.padding(5)
                                            Image(systemName: "chevron.down")
                                                .frame(width: bounds.size.width - 198 ,alignment: .trailing)
                                                .foregroundColor(.white)
                                            
                                            
                                        }.padding(.trailing, 2)
                                         .padding(.top, 5)
                                        .onTapGesture {
                                            withAnimation(.linear) {
                                                self.edituser = false
                                            }
                                        }
                                        HStack { //Displays an other HStack underneath in white so the user can enter the new username
                                            TextField("Enter new username", text: self.$newusername)
                                            
                                            Button(action: {
                                                    self.edituser = false
                                                    if self.newusername != "" { //Only saves the new username if the text field is not empty
                                                        self.complexSuccess()// Haptics so gives user feedback
                                                        self.saveUserName()
                                                    }
                                            }) {
                                                if self.newusername != "" { //Only show the save option if some kind of text are inputted
                                                Image(systemName: "square.and.arrow.down")
                                                    //.padding(.vertical)
                                                    .frame(width: bounds.size.width - 220 ,alignment: .trailing)
                                                    .foregroundColor(self.colorScheme == .light ? Color.black: Color.white)
                                                    .onAppear(perform: self.prepareHaptics)
                                                }
                                            }

                                        }.frame(width: bounds.size.width - 50) //So it allows the newly drawn hstack to be the same size as the rest of the list
                                        .padding()
                                        .background(self.colorScheme == .light ? Color.white: Color.black) //Will change the color based on the colorscheme
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
                                                self.showSettings = 2 //While cause the settings view to be redraw and used the ResetIntakeView() instead
                                                self.resetIntake() //Triggers in the background the daily intake parrallax view to be loaded.
                                            }
                                            
                                            
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .frame(width: bounds.size.width - 260  ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
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
                                        try! Auth.auth().signOut() //Causes the user to be logged out of the application
                                        GIDSignIn.sharedInstance()?.signOut() // If the user has logged in with Google then it will also be logged out
                                        UserDefaults.standard.set(false, forKey: "status") //Refers to the content view when launching the app so it will be redericted to the welcome screen
                                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                        
                                        self.showSettings = 3 //While cause the settings view to be redraw and used the LogoutView() instead
                                    }) {
                                        Image(systemName: "chevron.right")
                                        .frame(width: bounds.size.width - 155 ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
                                            .foregroundColor(.white)
                                    }
                                }.padding(.leading, 10)
                                .padding(.bottom, 5)
                            }.frame(width: bounds.size.width - 20)
                            .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12)
                            .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                            
                            Text("Reset your daily intake if you have lost weight or entered a field incorrectly during setup") //Information for the user
                                .lineLimit(2)
                                .font(.caption)
                                .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                
                                .frame(width: bounds.size.width - 20)
                                .fixedSize(horizontal: false, vertical: true)
                                //.padding(.bottom, 10)
                            VStack(alignment: .leading) {
                                HStack {
                                    Image("Info")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text("About FoodyScan")
                                        .foregroundColor(.black)
                                    
                                    NavigationLink(destination: AboutMeView()) { //Sends to an about me page about Foody Scan
                                        Image(systemName: "chevron.right")
                                            .frame(width:  bounds.size.width - 226 ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
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
                                    
                                    NavigationLink(destination: Text("Ratings")) { //Sends to the app store to rate the  application
                                        Image(systemName: "chevron.right")
                                            .frame(width:  bounds.size.width - 215  ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
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
                                    
                                    NavigationLink(destination: Text("What's new")) { //Sends to the app update log updated manually after all of the updates
                                    Image(systemName: "chevron.right")
                                        .frame(width:  bounds.size.width - 179,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
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
                                        if let url = URL(string: "https://twitter.com/TheFrenchGuyFr") { //Switches to the either safari where my twitter profile will be loaded or if twitter is installed it will open the twitter app
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                        .frame(width:  bounds.size.width - 248 ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
                                        .foregroundColor(.black)
                                    }
                                }.padding(.leading, 10)
                                .padding(.bottom, 5)
                            }.frame(width: bounds.size.width - 20)
                            .background(LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing)) //Background of the "list"
                            .cornerRadius(10)
                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                            .padding(.bottom, 20)
                            
                            
                            VStack {
                                HStack {
                                    Text("Request a new feature")
                                    Button(action: {
                                        self.showEmailAlert = true //Triggers an alert to be shown on the screen
                                    }) {
                                    Image(systemName: "chevron.right")
                                    .frame(width:  bounds.size.width - 220 ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
                                        .foregroundColor(.black)
                                    }.padding(.bottom, 5)
                                        .alert(isPresented: self.$showEmailAlert) {
                                            Alert(title: Text("FoodyScan Feedback"), message: Text("Please send an email to noedelacroix@protonmail.com"),primaryButton: .default(Text("Copy Email Address"), action: {
                                                UIPasteboard.general.string = "noedelacroix@protonmail.com"
                                            }), secondaryButton: .default(Text("Okay"))) //Copies to clipboard my email address so user can send feedback
                                    }
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Donation")
                                    
                                    Image(systemName: "chevron.right") //Will send to a in app purchase page later
                                    .frame(width:  bounds.size.width - 120 ,alignment: .trailing)
                                        .foregroundColor(.black)
                                }.padding(.bottom, 5)
                                
                                Divider()
                        
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text("Report a problem")
                                    
                                    Button(action :{
                                        self.showReportAlert = true //Triggers  an alert to be shown on the screen
                                    }) {
                                    Image(systemName: "chevron.right")
                                    .frame(width:  bounds.size.width - 210 ,alignment: .trailing) //So they are all of the same size and end distance from the screen on all iphone screens
                                        .foregroundColor(.black)
                                    }.alert(isPresented: self.$showReportAlert) {
                                            Alert(title: Text("Report Problem"), message: Text("Please send an email to noedelacroix@protonmail.com"),primaryButton: .default(Text("Copy Email Address"), action: {
                                                UIPasteboard.general.string = "noedelacroix@protonmail.com"
                                            }), secondaryButton: .default(Text("Okay"))) //Copies to clipboard my email address so user can send feedback
                                    }
                                }
                                
                                
                            }.frame(width: bounds.size.width - 20)
                                .padding(.vertical, 10)
                            .background(Color("BackgroundColor"))
                            .cornerRadius(5.0)
                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8) //To give the neumophirstic look to the user
                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                            
                            Text("If you enjoy FoodyScan please consider rating it on the App Store and maybe making a donation (it would help)") //Information to the user
                            .lineLimit(2)
                            .font(.caption)
                            .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                            
                            .frame(width: bounds.size.width - 20)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 20)
                            
                            Button(action: {
                                 self.presentation.wrappedValue.dismiss() //Later will allow all of the stored variables to be cleared
                            
                                
                            }){
                            HStack {
                                Text("Dismiss")
                            }.frame(width: bounds.size.width - 20)
                                .padding(.vertical, 10)
                                .foregroundColor(.offRed)
                            .background(Color("BackgroundColor"))
                            .cornerRadius(5.0)
                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                .padding(.bottom, 80)
                            }
                        }.frame(width: bounds.size.width)
                        .padding(.bottom, 80)
                    }
                }
                
                
            }.onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("UserName"),object: nil, queue: .main) { (_) in
                    self.username = UserDefaults.standard.value(forKey: "UserName") as? String ?? "User"
                    } //Fetches for changed in the username of the user
                }
            .frame(height: UIScreen.main.bounds.height)
        } //Sets the view to be the full width of the device
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.newusername, forKey: "UserName") //Saves the new username of the user to the username usersettings
        print("username saved") //Debug only
    }
    
    func resetIntake() { //Changes the values as seen on the contentview
        UserDefaults.standard.set(true, forKey: "status") // So that the user wont have to re loggin at launch of the app again and forces him to home screen of the app
        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil) //Created a notification so on content view can observe the modification
        
        UserDefaults.standard.set(false, forKey: "setup") // This means that the user wanted to reset daily intake so he must complete the daily intake calculator
        NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil) //Created a notification so on content view can observe the modification
    }
    
    func prepareHaptics() {
               guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { //Checks if the user devices has haptic supports
                   print("Haptic not supported by device") //Debug only
                   return
               }

               do {
                   self.engine = try CHHapticEngine()
                   try engine?.start()
               } catch {
                   print("There was an error creating the engine: \(error.localizedDescription)") //If there is an error preparingthe haptic engine
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
                   print("Failed to play pattern: \(error.localizedDescription).") //Debug only
               }
           }
}

struct SettingsBlockView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsBlockView(showSettings: .constant(1))
    }
}
