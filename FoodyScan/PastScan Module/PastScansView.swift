//
//  PastScansView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 31/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct PastScansView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode //Necessary in order to go back to the main menu as using custom color for the back button
    @Environment(\.managedObjectContext) var managedObjectContext //Necessary in order to fetch and save the coredata product stack
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct> //Fetches the coredate product stacks
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var eatenToday = EatenToday()
    @State var edit:Bool = false //whever the list is being edited

    var dateFormatter: DateFormatter { //Used in order to format the date so it is not too long for the screen
        let formatter = DateFormatter()
        formatter.dateStyle = .long //What is the size of the date
        return formatter
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear // tableview background
        UITableViewCell.appearance().backgroundColor = .clear // cell background
    }
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                
                List {
                    if self.edit { //If the list is being edited
                        Text("Editing")
                            .frame(width: bounds.size.width - 20, height: 40).padding(.leading, -10)
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStart, .gradientEnd]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                        ForEach(self.products, id: \.self) {
                            i in
                            VStack {
                                HStack {
                                    if i.image_front_small_url != "No image" {
                                        AnimatedImage(url: URL(string: i.image_front_small_url))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle()).shadow(radius: 20)
                                        .padding(.trailing, 10)
                                    } else {
                                        Image(systemName: "bag.fill")
                                         .resizable()
                                         .frame(width: 50, height: 60)
                                         .padding()
                                    }
                            
                                    VStack(alignment: .leading) {
                                        Text(i.product_name ?? "No Name")
                                            .bold()
                                        
                                        HStack {
                                            Image(systemName: "cube.box")
                                                .resizable()
                                                .padding()
                                            Text("Amount eaten: \(i.amountEaten)g")
                                        }
                                        Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                        Text("\(i.scanDate, formatter: self.dateFormatter)")
                                            .font(.caption)
                                    }
                                }
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: bounds.size.width - 20)
                                
                                
                            }
                            .background(Color("Color"))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            
                            .contextMenu { //When long pressing on the card of the food item a context menu pops up asking you if you'd like to delete the item
                                Button(action :{ self.delete(i) }) { //runs the function delete with the product card selected
                                    HStack {
                                        Image(systemName: "trash") //So the users see it
                                        Text("Delete")
                                        //Cant change the color has SwiftUI has a bug for it
                                    }
                                }
                            }
                        
                        }.onDelete(perform: { indexSet in //The only change when the list is being edited you can swipe from the right to delete the item
                                
                                let deleteProduct = self.products[indexSet.first!] //What product to delete
                                self.delete(deleteProduct)
                                self.managedObjectContext.delete(deleteProduct) //To actually delete the product from the list
                                
                                do {
                                    try self.managedObjectContext.save() //saves it to the coredata stacks
                                } catch {
                                    print(error) // if there is an error it is printed to the terminal
                                }
                                
                         })
                    }
                    else { //When the list is not being edited
                        ForEach(self.products, id: \.self) {
                            i in
                            
                            VStack {
                                
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    HStack {
                                        if i.image_front_small_url != "No image" {
                                            AnimatedImage(url: URL(string: i.image_front_small_url))
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle()).shadow(radius: 20)
                                                .padding(.leading, 20)
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
                                                
                                                VStack {
                                                    HStack {
                                                        Color.white
                                                            .mask(Image("Energy")
                                                            .resizable())
                                                            .frame(width: 16, height: 16)

                                                        Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal")
                                                    }
                                                    
                                                    HStack {
                                                        Color.white
                                                        .mask(Image("Sugar")
                                                        .resizable())
                                                        .frame(width: 16, height: 16)
                                                        
                                                         Text("Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                                    }
                                                }.padding(.trailing, 20)
                                                
                                                VStack {
                                                    HStack {
                                                        Color.white
                                                            .mask(Image("Protein")
                                                            .resizable())
                                                            .frame(width: 16, height: 16)

                                                        Text("Protein: \(i.proteinIn, specifier: "%.0f") g")
                                                    }
                                                    
                                                    HStack {
                                                        Color.white
                                                        .mask(Image("Salt")
                                                        .resizable())
                                                        .frame(width: 16, height: 16)
                                                        
                                                         Text("Salt: \(i.saltIn, specifier: "%.02f")g")
                                                    }
                                                }
                                            }
                                        }.frame(width: bounds.size.width - 180, alignment: .center)
                                    }.foregroundColor(.white)
                                    .padding(.vertical)
                                        .frame(width: bounds.size.width - 20, alignment: .leading).padding(.leading, -10)
                                } else {
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
                                
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                            .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                            
                            
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
                }.background(Color("BackgroundColor"))
                    
                    
                .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
                    HStack {
                        if self.edit { //If the list is being edited then the user cannot go back to the main screen
                            HStack {
                                GradientImageInv(image: "xmark", size: 18, width: 20 )
                                                   .padding(.top, 20)
                                GradientTextInv(title: "Editing", size: 16, width: 180)
                                                    .padding(.top , 10)
                            }
                            
                            HStack {
                                GradientImageInv(image: "pencil", size: 16, width: 20 ).padding(.top, 20) //Indicate to the user that the list is being edited
                                    .onTapGesture {
                                        self.edit = false //so can toggle between the state
                                    }
                                    .foregroundColor(.red) //red in order to inform the user the action happeing
                            }.padding(.leading, bounds.size.width - 260)
                        }
                    else { //If the list is not being edited the user can go back to the main screen
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss() // So that it returns to the previous view
                        }) { //UI at the top of the screen
                                HStack {
                                    GradientImage(image: "chevron.left", size: 18, width: 20 )
                                                       .padding(.top, 20)
                                    GradientText(title: "Main Menu", size: 16, width: 180)
                                        .padding(.top , 10)
                                }
                                
                                HStack {
                                    GradientImage(image: "trash", size: 16, width: 20 ).padding(.top, 20) //So can toggle to the editing state to remove items from the list
                                        .onTapGesture {
                                            self.edit = true
                                        }
                                        .foregroundColor(Color("Color"))
                                }.padding(.leading, bounds.size.width - 260)
                            }
                        }
                    }
                )
                
                
                
            }
        }
        
        
    }
    func delete(_ i:ListProduct) { //In order the delete the product card from the list
        let timediff = Int(Date().timeIntervalSince(self.eatenToday.startTime))
        
        if timediff >= 86400 {
            managedObjectContext.delete(i) //delte the card selected
            self.userSettings.eatentoday -= Double(i.energyInKcal)
            self.eatenToday.sugarToday -= Double(i.sugarIn)
            self.eatenToday.proteinToday -= Double(i.proteinIn)
            self.eatenToday.fatToday -= Double(i.fatIn)
            self.eatenToday.fiberToday -= Double(i.fiberIn)
            self.eatenToday.saltToday -= Double(i.saltIn)
            self.eatenToday.carbohydratesToday -= Double(i.carbohydratesIn)
        } else {managedObjectContext.delete(i)}
        
        do {
            try self.managedObjectContext.save() //saves it onto the coredata stacks
        } catch {
            print(error.localizedDescription) //Prints if there is an error
        }
    }
    
}

struct PastScansView_Previews: PreviewProvider {
    static var previews: some View {
        PastScansView()
    }
}
