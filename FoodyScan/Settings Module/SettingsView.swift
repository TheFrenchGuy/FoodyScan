//
//  SettingsView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 13/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
struct SettingsView: View {
     @Environment(\.presentationMode) var presentation
     
     @State var showSettings:Int = 1 //So the view can toggle between 3 stats (needed as the view wont be dismissed this is a known bug so i have to display a drag down animation when the view in the back ground changes)
    var body: some View {
        
        
        NavigationView {
            ZStack {
                if self.showSettings == 1{
                    SettingsBlockView(showSettings: $showSettings) //The view the user see when he taps on the settings icon/text in the menu
                }
                if self.showSettings == 2{
                    ResetIntakeView() //When the user select to reset his daily intake a drag down animation information the user that he needs to drag down to reset his daily intake
                }
                
                if self.showSettings == 3{
                    LogoutView() //When the user select to log out of the application , to make the view disappeer he needs to drag down the view in the background would already have been loaded.
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
