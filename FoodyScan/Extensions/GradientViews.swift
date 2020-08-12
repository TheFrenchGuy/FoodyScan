//
//  GradientViews.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import SwiftUI

struct GradientText: View {
    let title: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}


struct GradientTextInv: View {
    let title: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEnd, .gradientStart])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 35)
            .mask(Text("\(self.title)")
                .font(.system(size: CGFloat(self.size), weight: .heavy))
        )
    }
}
struct GradientImage: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEndDark, .gradientStartDark])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image)
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}


struct GradientImageInv: View {
    let image: String
    let size: Int
    let width: Int
    let colors = Gradient(colors: [.gradientEnd, .gradientStart])
    
    var body: some View {
        LinearGradient(gradient: colors,startPoint: .leading, endPoint: .trailing)
            .frame(width: CGFloat(self.width), height: 60)
            .mask(Image(systemName: self.image)
                .font(.system(size: CGFloat(self.size), weight: .semibold))
                .padding(.top, 10)
        )
    }
}
