//
//  DrawShape.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct DrawShape : View {
    
    
    var data: Array<Pie> //Data gotten from the information Daily view
    var center : CGPoint
    var index: Int
    
    
    var body: some View {
        
        Path{ path in //Draws a cirlce with varying angles so that it looks like a pie chart
            path.move(to: self.center)
            path.addArc(center: self.center, radius: 180, startAngle: .init(degrees: self.from()), endAngle: .init(degrees: self.to()), clockwise: false)
        }.fill(data[index].color)
            
    }
    
    //since anglis is continuouse so we need to calculate the angles before and with the current to get exact angle....
    
    func from()->Double { //At which point the chart should start
        
        if index  == 0 {
            return 0
        } else {
            var temp: Double = 0
            
            for i in 0...index-1 {
                temp += Double(data[i].percent / 100) * 360
            }
            
            return temp
        }
    }
    
    func to()->Double { //At whihc point the chart should end
        
        //converting percentage to angle ...
        
        var temp: Double = 0
        // because we need to current degree ...
        for i in 0...index {
            temp += Double(data[i].percent / 100) * 360
            
        }
        return temp
    }
}


