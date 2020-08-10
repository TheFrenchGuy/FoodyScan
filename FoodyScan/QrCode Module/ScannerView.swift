//
//  ScannerView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ScannerViewModel() //Refers to the scanner view model
    @Binding var showSelf: Bool //Whever the product view is shown
    var body: some View {
        ZStack { //Used a ZStack as the camera view will be in at the back so will take the entire screen
            
            if self.viewModel.lastQrCode != "" {
                ProductInfoView(showSelf: $showSelf)
            }
            else {
            QrCodeScannerView()
            .found(r: self.viewModel.onFoundQrCode)
            .torchLight(isOn: self.viewModel.torchIsOn)
            .interval(delay: self.viewModel.scanInterval)
            
            
            VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Text(self.viewModel.lastQrCode)
                        .bold()
                        .lineLimit(5)
                        .padding()
                }
                .padding(.vertical, 20)
                
                Spacer()
                HStack {
                    Button(action: {
                        self.viewModel.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color("Color"))
                            .padding()
                    })
                }
                .background(Color.white)
                .cornerRadius(10)
                
            }.padding()
            }
            
        }
    .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            self.viewModel.lastQrCode = ""// So that it returns to the previous view
        }) { //UI at the top of the screen
            HStack {
                GradientImage(image: "chevron.left", size: 18, width: 20 )
                    .padding(.top, 20)
                GradientText(title: "Main Menu", size: 16, width: 180)
                    .padding(.top, 10)
            }
    })
    .navigationBarTitle(Text("")) //No title for the view name
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(showSelf: .constant(true))
    }
}
