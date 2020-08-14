//
//  ResetIntakeView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 14/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct ResetIntakeView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Sets the background of the view
            VStack {
                LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing) //Used in order to display a gradient text
                    .frame(width: UIScreen.main.bounds.width, height: 70)
                    .mask(Text("Drag down to reset your daily intake") //Mask so that the text is the gradient choosene (can't be foreground color modifier as only accept UIColor)
                        .font(.system(size: 20, weight: .heavy))
                )
                    .frame(width: UIScreen.main.bounds.width, alignment: .center) //So that it takes the full width of the screen
                .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, UIScreen.main.bounds.width - 350) //So that the text is centered in the middle of the screen on all iphone models
                
                if self.colorScheme == .light { //If the iphone/ ipad theme is light
                LottieView(filename: "DownArrowLightLottie", speed: 1, loop: .loop) //Arrow pointing down with a foreground color of black
                    .frame(width: UIScreen.main.bounds.width * 0.3) //Scales well on all iphone screens
                }
                if self.colorScheme == .dark { //If the iphone/ ipad theme is dark
                    LottieView(filename: "DownArrowDarkLottie", speed: 1, loop: .loop) //Arrow pointing down with a foreground color of white
                    .frame(width: UIScreen.main.bounds.width * 0.3) // So that  it is not too large on the screen
                }
            }
        }
    }
}

struct ResetIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        ResetIntakeView()
    }
}
