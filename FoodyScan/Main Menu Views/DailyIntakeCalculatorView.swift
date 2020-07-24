//
//  DailyIntakeCalculatorView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 24/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct DailyIntakeCalculatorView: View {
    var body: some View {
        VStack {
            Text("Hey")
                
                Button(action: {
                    print("tapped")
                }) {
                    Text("Tap me")
                }
                
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "setup")
                    NotificationCenter.default.post(name: NSNotification.Name("setup"), object: nil)
                }) {
                    Text("Home")
                    }
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

struct DailyIntakeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeCalculatorView()
    }
}
