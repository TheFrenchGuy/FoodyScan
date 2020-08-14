//
//  TermsView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 09/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        ZStack {
             Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Sets the background of the app so it can be constant throughout the UI
            
            VStack {
                ScrollView {
                    VStack{
                    HStack(alignment: .center) {
                        Image("FoodyScanLargeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        GradientText(title: "Foody Scan", size: 24, width: 165)
                        
                        .font(.system(size: 24, weight: .heavy))
                    }
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    
                    .padding(.bottom, 50)
                     .padding(.top, 50)
                        
                        VStack(alignment: .leading) { //Details all of the privacy information of the app
                            Text("Your Data & Privacy")
                                .fontWeight(.heavy)
                                .font(.system(size: 28))
                                .frame(alignment: .leading)
                            
                            Text("Im still a student making a great food tracking app, not collecting your data")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black.opacity(0.7))
                                .padding(5)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    Image(systemName: "icloud")
                                Text("iCloud Sync")
                                    .bold()
                                }
                                Text("Sync your data across your Apple devices. All data is stored securely on your personal iCloud account")
                            }.padding(5)
                             .padding(.bottom, 20)
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    Image(systemName: "icloud")
                                Text("iCloud Sync")
                                    .bold()
                                }
                                Text("Sync your data across your Apple devices. All data is stored securely on your personal iCloud account")
                            }.padding(5)
                             .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    Image(systemName: "icloud")
                                Text("iCloud Sync")
                                    .bold()
                                }
                                Text("Sync your data across your Apple devices. All data is stored securely on your personal iCloud account")
                            }.padding(5)
                             .padding(.bottom, 20)
                            VStack(alignment: .leading, spacing: 5) {
                                
                                HStack {
                                    Image(systemName: "icloud")
                                Text("iCloud Sync")
                                    .bold()
                                }
                                Text("Sync your data across your Apple devices. All data is stored securely on your personal iCloud account")
                            }.padding(5)
                             .padding(.bottom, 10)
                            
                            Button(action: {
                                //Should open webpage
                            }) {
                                Text("View Privacy Policy") //Will send to either a website or another view to see the privacy policy
                                .font(.caption)
                                .foregroundColor(Color("Color"))
                                .padding(10)
                            }
                        }
                        
                    }
            }
                
                ZStack {
                    BlurView().edgesIgnoringSafeArea(.all)
                    VStack {
                        NavigationLink(destination: NameView()) { //Sends to the NameView
                            Text("Continue")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12) //Creates a newmophistic effect
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                        .padding(.bottom, 15)
                        
                        HStack {
                            Text("By continuing you also agree with the ")
                                .font(.system(size: 10))
                            Button(action: {
                                //Redirect to terms and conditions
                            }) {
                                Text("Terms of Use")
                                .foregroundColor(Color("Color"))
                                .bold()
                                .font(.system(size: 10))
                            }
                        }
                    }
                    }
                .frame(height: 110)
            }
        .navigationBarTitle("") //So that the there is navigation bar shown
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        }
    }
}


struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
