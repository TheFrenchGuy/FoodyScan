//
//  MainView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 14/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreHaptics
import SDWebImageSwiftUI
import UserNotifications

struct MainView : View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct>
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var userSettings = UserSettings()
    @Binding var showMenu: Bool
    @ObservedObject var eatenToday = EatenToday()
    @State var notificationhelper = UserDefaults.standard.value(forKey: "notificationhelper") as? Bool ?? false //Neccesary in order to show notification at the right time at 12pm and 6pm everyday

    var dateFormatter: DateFormatter { //Used in order to format the date so it is not too long for the screen
        let formatter = DateFormatter()
        formatter.dateStyle = .long //What is the size of the date
        return formatter
    }
    var body: some View {
        
            registerUserNotification() //Ask the user for notification permission
            dailyLunchNotification() //12pm notification about the user intake
            dailyEveningNotification() //6pm notification about the user intake
        
            return GeometryReader { bounds in
                    ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)//Sets the background color so it is the same color in all of the views
                
                ScrollView {
                    VStack(alignment: .center){
                        LottieView(filename: "FoodBowlLottie", speed: 1, loop: .loop) //Lottie animation at the top of the screen  check the LottieView for information
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3) //So that the animation is in the middle of the screen and is also the full width
                        
                        HStack {
                            Text("Your daily intake is")
                            Text("\(self.userSettings.dailyintakekcal, specifier: "%g")") //Mask the Text so it can be the correct color
                                    .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color("Color"))
                            Text("kcal a day")
                        }
                        
                        Divider().frame(width: bounds.size.width - 20) //Divides to give a clear division to the user
                        
                        HStack(alignment: .top) {
                            Text("Understand how your daily intake is calculated")
                                .font(.caption)
                            NavigationLink(destination: CalculatorHelpView()) { //Links to how the calculations are done
                                GradientText(title: "Here", size: 12, width: 40) //Click on this which stands out to the user
                            }
                        }
                        
                        
                        VStack {
                            if self.products.count == 0 { //If there is nothing in the pastscanmodel list
                                GradientText(title: "Eat it, Then start Scaning", size: 24, width: Int(bounds.size.width))
                                    .frame(width: bounds.size.width)
                                    .padding(.leading, bounds.size.width - 290)
                                
                            }
                            
                            else if self.products.count <= 2 { //if there is one or two scan in the model
                                Text("Firsts Few Scans")
                                .font(Font.custom("Dashing Unicorn", size: 20)) //Imported a custom font can be seen in the extension folder
                                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                ForEach(self.products, id: \.self) {
                                                           i in
                                                           VStack {
                                                               HStack {
                                                                   if i.image_front_small_url != "No image" {
                                                                       AnimatedImage(url: URL(string: i.image_front_small_url))
                                                                       .resizable()
                                                                       .frame(width: 40, height: 40)
                                                                       .clipShape(Circle()).shadow(radius: 20)
                                                                       //.padding(.trailing, 10)
                                                                   } else {
                                                                       Image(systemName: "bag.fill")
                                                                        .resizable()
                                                                        .frame(width: 40, height: 45)
                                                                       // .clipShape(Circle()).shadow(radius: 20)
                                                                        .padding()
                                                                   }
                                                           
                                                                   VStack(alignment: .leading) {
                                                                       Text(i.product_name ?? "No Name")
                                                                           .bold()
                                                                       HStack {
                                                                           Image(systemName: "cube.box")
                                                                               .resizable()
                                                                               .frame(width: 16, height: 16)
                                                                           Text("Amount eaten: \(i.amountEaten)g")
                                                                       }
                                                                       
                                                                       HStack {
                                                                           Color.white
                                                                               .mask(Image("Energy")
                                                                               .resizable())
                                                                               .frame(width: 16, height: 16)

                                                                           Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal")
                                                                           
                                                                           Color.white
                                                                           .mask(Image("Sugar")
                                                                           .resizable())
                                                                           .frame(width: 16, height: 16)
                                                                           
                                                                            Text("Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                                                       }
                                                                       Text("\(i.scanDate, formatter: self.dateFormatter)")
                                                                           .font(.caption)
                                                                   }
                                                               }
                                                               .foregroundColor(.white)
                                                               .padding(.vertical)
                                                               .frame(width: bounds.size.width - 20).padding(.leading, -10)
                                                               
                                                               
                                                           }
                                                           .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                                                           .cornerRadius(10)
                                                           
                                                           
                                                           .contextMenu { //When long pressing on the card of the food item a context menu pops up asking you if you'd like to delete the item
                                                               Button(action :{
                                                                   self.delete(i)
                                                               }) { //runs the function delete with the product card selected
                                                                   HStack {
                                                                       Image(systemName: "trash")  //So the users see it
                                                                       Text("Delete").foregroundColor(Color("Color"))
                                                                       //Cant change the color has SwiftUI has a bug for it
                                                                   }
                                                               }
                                                           }
                                                       
                                                       }
                            }
                            else if self.products.count >= 3 { //if there is more than 3 scan in the pastscan model list
                                Text("Last 3 product scanned")
                                .font(Font.custom("Dashing Unicorn", size: 20)) //Imported a custom font can be seen in the extension folder
                                    .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                                
                             ForEach(self.products.dropLast(self.products.count - 3), id: \.self) { //It will only show the last 3scans
                                i in
                                VStack {
                                    HStack {
                                        if i.image_front_small_url != "No image" {
                                            AnimatedImage(url: URL(string: i.image_front_small_url))
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle()).shadow(radius: 20)
                                            //.padding(.trailing, 10)
                                        } else {
                                            Image(systemName: "bag.fill")
                                             .resizable()
                                             .frame(width: 40, height: 45)
                                            // .clipShape(Circle()).shadow(radius: 20)
                                             .padding()
                                        }
                                
                                        VStack(alignment: .leading) {
                                            Text(i.product_name ?? "No Name")
                                                .bold()
                                            HStack {
                                                Image(systemName: "cube.box")
                                                    .resizable()
                                                    .frame(width: 16, height: 16)
                                                Text("Amount eaten: \(i.amountEaten)g")
                                            }
                                            
                                            HStack {
                                                Color.white
                                                    .mask(Image("Energy")
                                                    .resizable())
                                                    .frame(width: 16, height: 16)

                                                Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal")
                                                
                                                Color.white
                                                .mask(Image("Sugar")
                                                .resizable())
                                                .frame(width: 16, height: 16)
                                                
                                                 Text("Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                            }
                                            Text("\(i.scanDate, formatter: self.dateFormatter)")
                                                .font(.caption)
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: bounds.size.width - 20).padding(.leading, -10)
                                    
                                    
                                }
                                .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing)) //Sets the background of the scancard
                                .cornerRadius(10)
                                
                                
                                .contextMenu { //When long pressing on the card of the food item a context menu pops up asking you if you'd like to delete the item
                                    Button(action :{
                                        self.delete(i)
                                    }) { //runs the function delete with the product card selected
                                        HStack {
                                            Image(systemName: "trash")  //So the users see it
                                            Text("Delete").foregroundColor(Color("Color"))
                                            //Cant change the color has SwiftUI has a bug for it
                                        }
                                    }
                                }
                            
                            }
                            }
                            
                        }.padding(.bottom, 10)
                        
                        Divider().frame(width: bounds.size.width - 30).padding(.bottom, 70) //Padding so that it gives more space to scroll down and looks cleaner
                        
                        Spacer()
                        
                    }
                    
                }
                if self.products.count <= 1  {
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ShapeView().offset(x: bounds.size.width * 0.4, y : bounds.size.height * 0.5 )
                    }
                }
            }
            .onAppear { //Fetches the variables needed so the dialy intake can be upadated as soon as the user sign in or reset his daily intake
                
                
                
                 NotificationCenter.default.addObserver(forName: NSNotification.Name("notificationhelper"), object: nil, queue: .main) { (_) in
                                 
                 self.notificationhelper = UserDefaults.standard.value(forKey: "notificationhelper") as? Bool ?? false //In order to fetch if the state has changed to display the notificatin helper alert
                 }
                
                
                 NotificationCenter.default.addObserver(forName: NSNotification.Name("birthdate"), object: nil, queue: .main) { (_) in
                     
                    self.userSettings.birthdate = UserDefaults.standard.value(forKey: "birthdate") as? Date ?? Date()
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("dailyintakekcal"), object: nil, queue: .main) { (_) in
                                    
                    self.userSettings.dailyintakekcal = UserDefaults.standard.value(forKey: "dailyintakekcal") as? Double ?? 1000.0
                        
                    }
                        
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("height"), object: nil, queue: .main) { (_) in
                                        
                            self.userSettings.height = UserDefaults.standard.value(forKey: "height") as? Double ?? 1.0
                        
                        }
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("weight"), object: nil, queue: .main) { (_) in
                                    
                        self.userSettings.weight = UserDefaults.standard.value(forKey: "weight") as? Double ?? 1.0
                    
                    }
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("gender"), object: nil, queue: .main) { (_) in
                                    
                        self.userSettings.gender = UserDefaults.standard.value(forKey: "gender") as? String ?? "Other"
                    
                    }
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("activitylevel"), object: nil, queue: .main) { (_) in
                                    
                        self.userSettings.activitylevel = UserDefaults.standard.value(forKey: "activitylevel") as? Int ?? 1
                    
                    }
                    
                }
                    }
        }
    }
    
    func delete(_ i:ListProduct) { //In order the delete the product card from the list
        let timediff = Int(Date().timeIntervalSince(i.scanDate))
        
        if timediff <= 86400 { //So if it less than a day since the app has been started then the data is being deleted
            self.userSettings.eatentoday -= Double(i.energyInKcal)
            self.eatenToday.sugarToday -= Double(i.sugarIn)
            self.eatenToday.proteinToday -= Double(i.proteinIn)
            self.eatenToday.fatToday -= Double(i.fatIn)
            self.eatenToday.fiberToday -= Double(i.fiberIn)
            self.eatenToday.saltToday -= Double(i.saltIn)
            self.eatenToday.carbohydratesToday -= Double(i.carbohydratesIn)
            managedObjectContext.delete(i) //delte the card selected
        } else {managedObjectContext.delete(i)}
        
        do {
            try self.managedObjectContext.save() //saves it onto the coredata stacks
        } catch {
            print(error.localizedDescription) //Prints if there is an error
        }
    }
    
    func registerUserNotification() {
        
        if self.notificationhelper {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All Set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                        print("Failed")
                    }
            }
            
            UserDefaults.standard.set(false, forKey: "notificationhelper")
        }
    }
    
    func dailyLunchNotification() {
                let eatencalpercentage = Int((UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100) //The percentage of the user daily intake he has eaten
                let content = UNMutableNotificationContent() //What kind of notification it is
                content.title = "Daily Morning Notification" //Title
                content.body = "You had \(eatencalpercentage)% of your calorie daily intake" //Main message
                content.sound = UNNotificationSound.default //The sound of the notification

               var dateInfo = DateComponents() //When should the notifaction be displayed
               dateInfo.hour = 12
               dateInfo.minute = 0
               let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true) //So when the system clock matches that time a notification is displayed
            //   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //Degub only
                let request = UNNotificationRequest(identifier: "Lunch", content: content, trigger: trigger) //Sets the notification name to the system
                UNUserNotificationCenter.current().add(request) //Adds the request to the system to display that notification
    }
    
    func dailyEveningNotification() { //Documentation is the same as above
                let eatencalpercentage = Int((UserSettings().eatentoday / UserSettings().dailyintakekcal) * 100)
                let content = UNMutableNotificationContent()
                content.title = "Daily Evening Notification"
                content.body = "You had \(eatencalpercentage)% of your calorie daily intake"
                content.sound = UNNotificationSound.default

                var dateInfo = DateComponents() //Notification being displayed at 6pm local time 
                dateInfo.hour = 18
                dateInfo.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
              // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "Dinner", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMenu: .constant(false))
    }
}
