//
//  GradientViews.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import SwiftUI



//Create gradients for both images and text so can create a system wide theme
struct GradientText: View {
    let title: String //The text to be displayed
    let size: Int //The size of the text
    let width: Int //Necessary as if not the text will not be displayed correclty dependent on the lenght of the text
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark]) //What gradient color to select
    
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)") //Mask the Text so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}


struct GradientTextInv: View {
    let title: String //The text to be displayed
    let size: Int //The size of the text
    let width: Int //Necessary as if not the text will not be displayed correclty dependent on the lenght of the text
    let colors = Gradient(colors: [.gradientEnd, .gradientStart]) //What gradient color to select
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")//Mask the Text so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}
struct GradientImage: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark]) //What gradient color to select
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image) //Mask the Image so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}


struct GradientImageInv: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEnd, .gradientStart]) //What gradient color to select
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image) //Mask the Image so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}


struct GradientTextSec: View {
    let title: String //The text to be displayed
    let size: Int //The size of the text
    let width: Int //Necessary as if not the text will not be displayed correclty dependent on the lenght of the text
    let colors = Gradient(colors: [.gradientSecondaryEnd, .gradientSecondaryStart]) //What gradient color to select
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")//Mask the Text so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}
struct GradientImageSec: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientSecondaryEnd, .gradientSecondaryStart]) //What gradient color to select
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image) //Mask the Image so it can be the correct color
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}
