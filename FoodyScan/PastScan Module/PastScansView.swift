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
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct>
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        VStack {
            List {
                 
                ForEach(self.products) {
                    i in
                    VStack {
                        HStack {
                            AnimatedImage(url: URL(string: i.image_front_small_url ?? "NoImage"))
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle()).shadow(radius: 20)
                            .padding(.trailing, 10)
                    
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
                }
            }
            .navigationBarItems(leading: //Made so the back button is the same color scheme as the app
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss() // So that it returns to the previous view
                }) { //UI at the top of the screen
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Main Menu")
                        
                        
                        
                    }.foregroundColor(Color("Color"))
            }
            
            )
            
            
            
        }
        
        
    }
    func delete(_ i:ListProduct) {
        managedObjectContext.delete(i)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct PastScansView_Previews: PreviewProvider {
    static var previews: some View {
        PastScansView()
    }
}
