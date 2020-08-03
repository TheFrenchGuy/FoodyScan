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
    @State private var showQrView = false
    @Environment(\.managedObjectContext) var productenv //Neccesary as sets the view from different hiearchay can also sync up with the coredata stack
    var username = UserDefaults.standard.string(forKey: "UserName") ?? "Error"
    var email =  UserDefaults.standard.string(forKey: "email") ?? "Error" 
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Welcome \(username)")
                    .foregroundColor(.gray)
                    .font(.title)
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
                NavigationLink(destination: Text("Daily Intake View")) {
                    Image(systemName: "chart.bar")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Daily Intake")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer(minLength: 300)
            
            HStack {
                
                NavigationLink(destination: Text("Settings View")) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer()
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
