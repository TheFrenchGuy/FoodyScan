//
//  DailyIntakeView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 05/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct DailyIntakeView: View {
    var body: some View {
        PieView()
    }
}

//Pie Data
//let leftpercentage = ((UserSettings().dailyintakekcal - UserSettings().eatentoday) / UserSettings().dailyintakekcal) * 100
//let eatenpercentage = (UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100


struct Pie: Identifiable {
    var id: Int
    var percent: CGFloat
    var name: String
    var color: LinearGradient
}


struct PieView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var eatenToday = EatenToday()
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        InformationDailyView()
              .onAppear {
                    let timediff = Int(Date().timeIntervalSince(self.eatenToday.startTime))
                    if timediff >= 86400 {
                        self.eatenToday.firstItemDay = true
                        self.eatenToday.sugarToday = 0.0
                        self.eatenToday.proteinToday = 0.0
                    }
                
                
        }
        .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) { //UI at the top of the screen
                HStack {
                    GradientImage(image: "chevron.left", size: 18, width: 20)
                        .padding(.top, 20)
                    GradientText(title: "Back", size: 16, width: 180)
                        .padding(.top, 10)
                }
        })
        .animation(.spring())
    }
}





struct DailyIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeView()
    }
}
