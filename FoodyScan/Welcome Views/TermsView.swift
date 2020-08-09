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
             Color.offWhite.edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    VStack{
                    HStack(alignment: .center) {
                        Image("FoodyScanLargeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        Text("Foody Scan")
                        .foregroundColor(Color("Color"))
                            .font(.system(size: 24, weight: .heavy))
                    }.padding(.bottom, 50)
                     .padding(.top, 50)
                        
                        VStack(alignment: .leading) {
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
                                Text("View Privacy Policy")
                                .font(.caption)
                                .foregroundColor(Color("Color"))
                                .padding(10)
                            }
                        }
                        
                    }
            }
                
                ZStack {
                    Color.black.opacity(0.7).edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        NavigationLink(destination: NameView()) {
                            Text("Continue")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                        }.background(Color("Color"))
                        .cornerRadius(10)
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
                }.frame(height: 110)
            }
        .navigationBarTitle("")
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
