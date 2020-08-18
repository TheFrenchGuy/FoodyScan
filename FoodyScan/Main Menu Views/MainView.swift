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

struct MainView : View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct>
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var userSettings = UserSettings()
    @Binding var showMenu: Bool
    @ObservedObject var eatenToday = EatenToday()

    var dateFormatter: DateFormatter { //Used in order to format the date so it is not too long for the screen
        let formatter = DateFormatter()
        formatter.dateStyle = .long //What is the size of the date
        return formatter
    }
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all) //Sets the background color so it is the same color in all of the views
            ScrollView {
                VStack(alignment: .center){
                    LottieView(filename: "FoodBowlLottie", speed: 1, loop: .loop) //Lottie animation at the top of the screen  check the LottieView for information
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3) //So that the animation is in the middle of the screen and is also the full width
                    
                    HStack {
                        Text("Your daily intake is")
                        LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]),startPoint: .leading, endPoint: .trailing)
                            .frame(width: UIScreen.main.bounds.width * 0.24, height: 25)
                            .mask(Text("\(userSettings.dailyintakekcal, specifier: "%g")") //Mask the Text so it can be the correct color
                                .font(.system(size: 20, weight: .heavy))
                        )
                        Text("kcal a day")
                    }
                    
                    Divider().frame(width: UIScreen.main.bounds.width - 20) //Divides to give a clear division to the user
                    
                    HStack(alignment: .top) {
                        Text("Understand how your daily intake is calculated")
                            .font(.caption)
                        NavigationLink(destination: CalculatorHelpView()) { //Links to how the calculations are done
                            GradientText(title: "Here", size: 12, width: 40) //Click on this which stands out to the user
                        }
                    }
                    
                    
                    VStack {
                        if self.products.count == 0 { //If there is nothing in the pastscanmodel list
                            GradientText(title: "Eat it, Then start Scaning", size: 24, width: Int(UIScreen.main.bounds.width))
                                .frame(width: UIScreen.main.bounds.width)
                                .padding(.leading, UIScreen.main.bounds.width - 290)
                            
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
                                                           .frame(width: UIScreen.main.bounds.width - 20).padding(.leading, -10)
                                                           
                                                           
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
                                .frame(width: UIScreen.main.bounds.width - 20).padding(.leading, -10)
                                
                                
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
                    
                    Divider().frame(width: UIScreen.main.bounds.width - 30).padding(.bottom, 70) //Padding so that it gives more space to scroll down and looks cleaner
                    
                    
                    
                    Spacer()
                    
                }
            }
        }
        .onAppear { //Fetches the variables needed so the dialy intake can be upadated as soon as the user sign in or reset his daily intake
             
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
    
    func delete(_ i:ListProduct) { //In order the delete the product card from the list
        
        managedObjectContext.delete(i) //delte the card selected
        self.userSettings.eatentoday -= Double(i.energyInKcal)
        self.eatenToday.sugarToday -= Double(i.sugarIn)
        self.eatenToday.proteinToday -= Double(i.proteinIn)
        self.eatenToday.fatToday -= Double(i.fatIn)
        self.eatenToday.fiberToday -= Double(i.fiberIn)
        self.eatenToday.saltToday -= Double(i.saltIn)
        self.eatenToday.carbohydratesToday -= Double(i.carbohydratesIn)
        
        
        do {
            try self.managedObjectContext.save() //saves it onto the coredata stacks
        } catch {
            print(error.localizedDescription) //Prints if there is an error
        }
    }
    
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMenu: .constant(false))
    }
}