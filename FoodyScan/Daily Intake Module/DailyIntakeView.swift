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


struct Pie: Identifiable { //Structure of the data to be inputted so can be used for the  view
    var id: Int
    var percent: CGFloat
    var name: String
    var color: LinearGradient
}


struct PieView: View {
    @Environment(\.colorScheme) var colorScheme //Fetches the colorscheme of the app
    @ObservedObject var userSettings = UserSettings() //Fetches the userSettings stored onto device storage
    @ObservedObject var eatenToday = EatenToday() //What the user has eaten today
    @Environment(\.presentationMode) var presentationMode //So that the user can go back to the main screen
   
    var body: some View {
        InformationDailyView()
              .onAppear {
                    let timediff = Int(Date().timeIntervalSince(self.eatenToday.startTime)) //If the app has been launched for more than a day since the first scan the the variables are whipped
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
