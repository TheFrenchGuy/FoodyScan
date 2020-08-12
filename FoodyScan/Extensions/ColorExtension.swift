//
//  ColorExtension.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import SwiftUI


extension Color { //Create an extension color for the view in order to make the neumorphic design stand out more
   static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
   static let colorLight = Color.black.opacity(0.7)
   static let colorDark = Color.white.opacity(0.7)
    
   static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
   static let gradientStartDark = Color(red: 95.0 / 255, green: 169.0 / 255, blue: 244.0 / 255)

   static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
   static let gradientEndDark = Color(red: 79.0 / 255, green: 178.0 / 255, blue: 141.0 / 255)
    
   static let gradientSecondaryStart = Color(red: 1 / 255, green: 37 / 255, blue: 255 / 255)
   static let gradientSecondaryEnd = Color(red: 237.0 / 255, green: 0 / 255, blue: 255 / 255)


}
