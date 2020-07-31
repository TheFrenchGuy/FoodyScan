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
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                            .padding()
                    })
                }
                .background(Color.white)
                .cornerRadius(10)
                
            }.padding()
            }
            
        }
    .navigationBarItems(leading:
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Main Menu")
            }.foregroundColor(Color("Color"))
    })
    .navigationBarTitle(Text(""))
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(showSelf: .constant(true))
    }
}
