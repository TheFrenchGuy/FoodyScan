//
//  LogoutView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 14/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct LogoutView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Background color of the screen (constant on all of the app views)
            VStack {
                LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing) //Used in order to display a gradient
                    .frame(width: UIScreen.main.bounds.width / 1.4, height: 70) //Used so that the text is centered on the screen
                    .mask(Text("Drag Down to return to welcome screen")
                        .font(.system(size: 20, weight: .heavy))
                )
                    .frame(width: UIScreen.main.bounds.width , alignment: .center) //So that the Vertical Stacks takes the whole width of the screen
                    .fixedSize(horizontal: false, vertical: true) //So the text can wrap for smaller iphone screens
                    .padding(.leading, UIScreen.main.bounds.width - 340) //Centered on the screen
                
                if self.colorScheme == .light { //Depended on the user selected theme so it looks great on dark and light mode
                LottieView(filename: "DownArrowLightLottie", speed: 1, loop: .loop)
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                }
                if self.colorScheme == .dark {
                    LottieView(filename: "DownArrowDarkLottie", speed: 1, loop: .loop)
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                }
            }
        }
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutView()
    }
}
