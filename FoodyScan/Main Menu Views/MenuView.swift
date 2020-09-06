//
//  MenuView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 24/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase

struct MenuView: View {
    @State private var showQrView: Bool = false
    @State var showSetting: Bool = false
    @Environment(\.managedObjectContext) var productenv //Neccesary as sets the view from different hiearchay can also sync up with the coredata stack
    var username = UserDefaults.standard.string(forKey: "UserName") ?? "Error"
    var email =  UserDefaults.standard.string(forKey: "email") ?? "Error" 
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome")
                    .foregroundColor(.gray)
                    .font(.title)
                GradientText(title: username, size: 20, width: 120)
                    .padding(.top, 12)
            }.padding(.top , 150)
            HStack {
                NavigationLink(destination: ScannerView(showSelf: $showQrView), isActive: $showQrView){ //Goes to the QR scanning view. Only shown when the showQRView is true.
                
                    Image(systemName: "barcode.viewfinder")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Barcode Scanner")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                
                NavigationLink(destination: PastScansView().environment(\.managedObjectContext, self.productenv)) { //Selectes which env to take from for the Core Data has otherwise the app will crash when trying to fetch the past products scans.
                    Image(systemName: "cart")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Past Scan")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                NavigationLink(destination: DailyIntakeView()) {
                    Image(systemName: "chart.bar")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Daily Intake")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer(minLength: 120)
            
            HStack {
                
                Button(action: {
                    self.showSetting = true //When the button is pressed it will trigger the settings sheet ot be presented
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }.padding(.top, 30)
            .sheet(isPresented: $showSetting) {
                SettingsView() //If the show setting is true then the SettingsView is shown
                
            }
            
            Spacer() // So it goes down to the end of the screen looks better
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
