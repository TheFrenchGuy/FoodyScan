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
     @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false //Wethever the user is logged in
     @State var setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false //Wethever the user is logged in
    
     var body: some View{
            NavigationView {
                VStack {
                    if self.status{
                        if self.setup { //So if already logged in the past then it will go straight to the main menu
                            HomeScreenView()
                        } else { //if it has not logged in before goes to the Daily Intake
                            DailyIntakeParrallax() //Where the user will be able to continue with the setup of the account
                        }
                    }
                    else {
                        ZStack {
                            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                            
                            VStack{
                                HStack(alignment: .center) {
                                Image("FoodyScanLargeIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(18)
                                    .padding()
                                //Text("Foody Scan")
                                  //  .foregroundColor(Color("Color"))
                                    //    .font(.system(size: 28, weight: .heavy))
                                    GradientText(title: "Foody Scan", size: 28, width: 165)
                            }
                                VStack {
                                    Text("Welcome to FoodyScan")
                                        .font(.system(size: 28, weight: .heavy))
                                    Text("The application the keeps track of your intake")
                                        .font(.system(size: 15))
                                }
                                
                                Spacer()
                                NavigationLink(destination: TermsView()) {
                                    Text("Get Started")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                }.background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(10)
                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                .padding(.bottom, 25)
                            }.padding(.top, 30)
                        }
                    }
                    
                
                    
                }.navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                 
                     NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                         
                         self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("setup"), object: nil, queue: .main) { (_) in
                                        
                        self.setup = UserDefaults.standard.value(forKey: "setup") as? Bool ?? false
                        }
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            //Neccessary in order to display the app as a single view other wise it will not work properly when navigation link are used or a large display is used
             
         }
 }

struct GradientText: View {
    let title: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}


struct GradientTextInv: View {
    let title: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEnd, .gradientStart])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}
struct GradientImage: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image)
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}


struct GradientImageInv: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEnd, .gradientStart])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image)
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}


extension Color { //Create an extension color for the view in order to make the neumorphic design stand out more
   static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
   static let colorLight = Color.black.opacity(0.7)
   static let colorDark = Color.white.opacity(0.7)
    
   static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
   static let gradientStartDark = Color(red: 95.0 / 255, green: 169.0 / 255, blue: 244.0 / 255)

  static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
  static let gradientEndDark = Color(red: 79.0 / 255, green: 178.0 / 255, blue: 141.0 / 255)

}


                 
