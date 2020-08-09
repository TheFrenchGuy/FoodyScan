//
//  LoginSignUpView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 09/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct LoginSignUpView: View {
    @State var show = false //will if true show the SignUp view
    var body: some View {
        ZStack{
                
                NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                    //Sends to SignUp view
                    EmptyView()
                }
                .hidden()
                
                Login(show: self.$show)
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    
}

struct LoginSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpView()
    }
}
