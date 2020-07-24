//
//  ErrorView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ErrorView : View {
    //Created in order to present the user when an error loggin in has been encountered
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool //Wethever an alert is active
    @Binding var error : String //Holds the error from the alert to the user
    
    var body: some View{
        
        GeometryReader{_ in //defines content as a function of its own size and coordinate space.
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error") //States at the top of the pop up wethever it has worked when the users presses on the forget password or an error has occured
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error) //Set the var error to be equlat to "Reset" to send a reset password link to the user when the user presses on forgot passowrd if an error occurs then the error is presented to the user
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle() //Triggers an alert to show on the screen
                    
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" : "Cancel") //If the email field is filled out then ok will be printed otherwise cancel will be printed as a button
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

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(false), error: .constant("No"))
    }
}
