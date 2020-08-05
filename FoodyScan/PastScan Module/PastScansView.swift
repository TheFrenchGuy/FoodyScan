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
    @Environment(\.presentationMode) var presentationMode //Necessary in order to go back to the main menu as using custom color for the back button
    @Environment(\.managedObjectContext) var managedObjectContext //Necessary in order to fetch and save the coredata product stack
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct> //Fetches the coredate product stacks
    @ObservedObject var userSettings = UserSettings()
    @State var edit:Bool = false //whever the list is being edited

    var dateFormatter: DateFormatter { //Used in order to format the date so it is not too long for the screen
        let formatter = DateFormatter()
        formatter.dateStyle = .long //What is the size of the date
        return formatter
    }
    
    var body: some View {
        VStack {
            List {
                if self.edit { //If the list is being edited
                    ForEach(self.products, id: \.self) {
                        i in
                        VStack {
                            HStack {
                                if i.image_front_small_url != "No image" {
                                    AnimatedImage(url: URL(string: i.image_front_small_url))
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle()).shadow(radius: 20)
                                    .padding(.trailing, 10)
                                } else {
                                    Image(systemName: "bag.fill")
                                     .resizable()
                                     .frame(width: 60, height: 70)
                                    // .clipShape(Circle()).shadow(radius: 20)
                                     .padding()
                                }
                        
                                VStack(alignment: .leading) {
                                    Text(i.product_name ?? "No Name")
                                        .bold()
                                    Text("Amount eaten: \(i.amountEaten)g")
                                    Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                    Text("\(i.scanDate, formatter: self.dateFormatter)")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 20)
                            
                            
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
                            HStack {
                                if i.image_front_small_url != "No image" {
                                    AnimatedImage(url: URL(string: i.image_front_small_url))
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle()).shadow(radius: 20)
                                    .padding(.trailing, 10)
                                } else {
                                    Image(systemName: "bag.fill")
                                     .resizable()
                                     .frame(width: 60, height: 70)
                                    // .clipShape(Circle()).shadow(radius: 20)
                                     .padding()
                                }
                        
                                VStack(alignment: .leading) {
                                    Text(i.product_name ?? "No Name")
                                        .bold()
                                    Text("Amount eaten: \(i.amountEaten)g")
                                    Text("Energy: \(i.energyInKcal, specifier: "%.0f") kcal Sugar: \(i.sugarIn, specifier: "%.02f")g")
                                    Text("\(i.scanDate, formatter: self.dateFormatter)")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 20)
                            
                            
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        
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
                
            }
            .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
                HStack {
                    if self.edit { //If the list is being edited then the user cannot go back to the main screen
                        HStack {
                            Image(systemName: "xmark")
                            Text("Editing")
                        }
                            .onTapGesture { //The top bar item changes name and color
                            self.edit = false
                            }
                            .foregroundColor(.red)
                        
                        HStack {
                            Image(systemName: "pencil") //Indicate to the user that the list is being edited
                                .onTapGesture {
                                    self.edit = false //so can toggle between the state
                                }
                                .foregroundColor(.red) //red in order to inform the user the action happeing
                        }.padding(.leading, UIScreen.main.bounds.width - 135)
                    }
                else { //If the list is not being edited the user can go back to the main screen
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss() // So that it returns to the previous view
                    }) { //UI at the top of the screen
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Main Menu")
                            }.foregroundColor(Color("Color"))
                            
                            HStack {
                                Image(systemName: "trash") //So can toggle to the editing state to remove items from the list
                                    .onTapGesture {
                                        self.edit = true
                                    }
                                    .foregroundColor(Color("Color"))
                            }.padding(.leading, UIScreen.main.bounds.width - 160)
                        }
                    }
                }
            )
            
            
            
        }
        
        
    }
    func delete(_ i:ListProduct) { //In order the delete the product card from the list
        
        managedObjectContext.delete(i) //delte the card selected
        self.userSettings.eatentoday -= Double(i.energyInKcal)
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