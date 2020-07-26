//
//  ProductInfoView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//
 
import SwiftUI

struct ProductInfoView: View {
     @ObservedObject var viewModel = ScannerViewModel()
     @Binding var showSelf:Bool
    var body: some View {
            VStack {
                Text("\(self.viewModel.lastQrCode)")
                Button(action: {
                    self.showSelf = false
                    self.viewModel.lastQrCode = ""
                }) {
                    Text("Go home")
                }
            }
            
    }
    
}

struct ProductInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoView(showSelf: .constant(true))
    }
}
