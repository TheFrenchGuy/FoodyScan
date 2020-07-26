//
//  HomeScreenView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct HomeScreenView: View {
    
   @State var showMenu = false
   
   var body: some View {
    
       let drag = DragGesture()
           .onEnded {
               if $0.translation.width < -100 {
                   withAnimation {
                       self.showMenu = false
                   }
               }
       }
       
       
       return NavigationView {
        
           GeometryReader { geometry in
               ZStack(alignment: .leading) {
                   MainView(showMenu: self.$showMenu)
                       .frame(width: geometry.size.width, height: geometry.size.height)
                       .offset(x: self.showMenu ? geometry.size.width / 2 : 0)
                       .disabled(self.showMenu ? true : false)
                   if self.showMenu {
                       MenuView()
                           .frame(width: geometry.size.width/2)
                           .transition(.move(edge: .leading))
                   }
               }
               .gesture(drag)
           }
           .navigationBarTitle("Main Menu", displayMode: .inline)
           .navigationBarItems(leading: (
               Button(action: {
                   withAnimation {
                       self.showMenu.toggle()
                   }
               }) {
                   Image(systemName: "line.horizontal.3")
                       .imageScale(.large)
                .foregroundColor(Color("Color"))
               }
           ))
       }
      .navigationViewStyle(StackNavigationViewStyle())
           
   }
}

struct MainView : View {
    @ObservedObject var userSettings = UserSettings()
    @Binding var showMenu: Bool
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text(Auth.auth().currentUser?.email ?? "Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.7))
                
                Text("You need to eat \(userSettings.dailyintakekcal,specifier: "%g") kcal a day")
                
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }) {
                    
                    Text("Log out")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
