//
//  ProductNotFound.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 18/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Combine

struct ProductNotFound: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext //Neccessary in order to store the scanned products into CoreData Stcak
    
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var QRviewModel = ScannerViewModel() //Where the QRcode is gotten
    @ObservedObject var eatenToday = EatenToday()
    
    @Binding var showSelf:Bool
    @State var manualEntry:Bool = false //Allows the user to either go back or to add a custom item
    
    @State var brand:String = ""
    @State var product:String = ""
    @State var sugar: String = ""
    @State var energy: String  = ""
    @State var carb: String = ""
    @State var fat: String = ""
    @State var fiber: String = ""
    @State var protein: String = ""
    @State var salt: String = ""
    @State var amounteaten: String = ""
    
    @State var scanDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                if self.manualEntry == false {
                    Text("Product Not Found")
                        .foregroundColor(.offRed)
                        .fontWeight(.black)
                        .padding(.top, 40)
                        
                    LottieView(filename: "ErrorLottie", speed: 1, loop: .repeat(2))
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.3)
                        .padding(.bottom, 40)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.linear) {
                            self.manualEntry = true
                        }
                    }) {
                        Text("Enter product manually")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(5.0)
                        .shadow(color: Color("LightShadow"), radius: 12, x: -12, y: -12) //Creates a newmophistic effect
                        .shadow(color: Color("DarkShadow"), radius: 12, x: 12, y: 12)
                        .padding(.bottom, 15)
                    }
                }
                if self.manualEntry {
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "bag.fill")
                             .resizable()
                             .frame(width: 60, height: 70)
                            // .clipShape(Circle()).shadow(radius: 20)
                             .padding()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                TextField("Product Brand", text: $brand)
                                TextField("Product Name", text: $product)
                                Text("Product Added Manually")
                                    .bold()
                            }
                        }
                        .foregroundColor(self.colorScheme == .light ? Color.colorDark: Color.colorLight) //Inverted the colors as it looked better that way on the green background
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }.background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    .padding(.top, 25)
                    
                    Spacer(minLength: 50)
                    
                    VStack {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("For 100g: ")
                                    .bold()
                                HStack(alignment: .center) {
                                    Image("Sugar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("Sugar").bold()
                                    TextField("...", text: $sugar)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(sugar)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.sugar = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 186)
                                    Text("g")
                                }
                                
                                HStack {
                                    Image("Energy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    Text("kcal").bold()
                                    TextField("...", text: $energy)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(energy)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.energy = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 172)
                                    Text("g")
                                }
                                
                                HStack {
                                    Image("Carbohydrates")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    Text("Carb").bold()
                                   TextField("...", text: $carb)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(carb)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.carb = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 178)
                                    Text("g")
                                }
                             
                            }
                        }
                        .foregroundColor(Color("Color"))
                        
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        }
                    .background(BlurView())
                    .cornerRadius(12)
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    .padding(.top, 5)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Image("Fat")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("Fat").bold()
                                    TextField("...", text: $fat)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(fat)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.fat = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 165)
                                    Text("g")
                                }
                                
                                
                                HStack(alignment: .center) {
                                    Image("Fiber")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("Fiber").bold()
                                    TextField("...", text: $fiber)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(fiber)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.fiber = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 180)
                                    Text("g")
                                }
                                
                                HStack(alignment: .center) {
                                    Image("Protein")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("Protein").bold()
                                    TextField("...", text: $protein)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(protein)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.protein = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 196)
                                    Text("g")
                                }
                                
                                HStack(alignment: .center) {
                                    
                                    Image("Salt")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("Salt").bold()
                                    TextField("...", text: $salt)
                                    .keyboardType(.numberPad)
                                        .onReceive(Just(salt)) { newValue in //Filteres so only numbers can be inputed
                                            let filtered = newValue.filter { "0123456789.".contains($0) } //It can only contains numbers
                                            if filtered != newValue {
                                                self.salt = filtered
                                            }
                                    }
                                    .frame(width: 30)
                                    .padding(.leading, UIScreen.main.bounds.width - 170)
                                    Text("g")
                                }
                            }
                            
                        }
                        .foregroundColor(self.colorScheme == .light ? Color.colorLight: Color.colorDark)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                    .padding(.top, 5)
                    
                   Spacer(minLength: 50)
                       
                   VStack {
                       
                       HStack {
                       Image(systemName: "cube.box")
                       TextField("Rough Amount Eaten", text: self.$amounteaten) //Input the rough amount eaten of the product
                       .keyboardType(.numberPad)
                           .onReceive(Just(amounteaten)) { newValue in //Filteres so only numbers can be inputed
                               let filtered = newValue.filter { "0123456789".contains($0) } //It can only contains numbers
                               if filtered != newValue {
                                   self.amounteaten = filtered
                               }
                       }
                       Text("grams")
                       }.padding()
                           .background(RoundedRectangle(cornerRadius: 25).stroke(self.amounteaten != "" ? Color("Color") : self.colorScheme == .light ? Color.colorLight: Color.colorDark,lineWidth: 2)) //Changes the color when the user inputs into  the text field
                       .frame(width: UIScreen.main.bounds.width - 20)
                           .onTapGesture {
                               self.hideKeyboard()
                       }
                   }.padding(10)
                
                    Spacer(minLength: 32)
                    
                    VStack {
                        Button(action: {
                            self.addlist() //Sves the data to the CoreData stack
                            self.todayStore()
                            self.showSelf = false //Returns to the homeview
                            self.QRviewModel.lastQrCode = "" //Clears the QRCode so can start again
                            self.userSettings.eatentoday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.energy) ?? 0.0) / 100)
                        }) {
                            Text("Add to list")
                            .fontWeight(.light)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 80)
                            .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color("Color"), lineWidth: 5)
                            )
                        }
                    }.padding(.bottom, 20)
                }
                
            }
        }
    }
    
    func addlist() { //Used to store the scan result into CoreData so can be later used for the pastScan views
        let i = ListProduct(context: self.managedObjectContext)
        
        i.productID = UUID() //Neccessary in order so that each of the product have a unique ID so can be shown in the list
        i.scanDate = self.scanDate
        //Rest of the variables used for the list
        i.brands = self.brand
        i.brand_owner_imported  = self.brand
        i.product_name = self.product
        i.image_front_small_url = "No Image"
        i.categories = "Manual"
        i.sugars_100g = Double(self.sugar) ?? 0.0
        i.energykcal_100g = Int16(self.energy) ?? Int16(0)
        i.fat_100g = Double(self.fat) ?? 0.0
        i.fiber_100g = Double(self.fiber) ?? 0.0
        i.proteins_100g = Double(self.protein) ?? 0.0
        i.salt_100g = Double(self.salt) ?? 0.0
        i.carbohydrates_100g = Double(self.carb) ?? 0.0
        i.amountEaten = Int16(self.amounteaten) ?? Int16(0)
        let amounteaten = Double(self.amounteaten) ?? 0.0
        i.sugarIn = ((amounteaten ) / 100 ) * (Double(self.sugar) ?? 0.0)
        i.energyInKcal = ((amounteaten ) / 100 ) * (Double(self.energy) ?? 0.0)
        
        i.proteinIn = ((amounteaten ) / 100 ) * (Double(self.protein) ?? 0.0)
        i.fatIn = ((amounteaten ) / 100 ) * (Double(self.fat) ?? 0.0)
        i.fiberIn = ((amounteaten ) / 100 ) * (Double(self.fiber) ?? 0.0)
        i.saltIn = ((amounteaten ) / 100 ) * (Double(self.salt) ?? 0.0)
        i.carbohydratesIn = ((amounteaten ) / 100 ) * (Double(self.carb) ?? 0.0)
        
        do {
            try self.managedObjectContext.save()
            print("Product Added to list")
        }catch {
            print("error inserting list")
        }
    }
    
    func todayStore() {
        let i = eatenToday
        let timediff = Int(Date().timeIntervalSince(self.eatenToday.startTime))
        print("\(Int(Date().timeIntervalSince(self.eatenToday.startTime)))")
        
        
        if timediff >= 86400 {
            i.firstItemDay = true
            self.userSettings.eatentoday = 0.0
            i.sugarToday = 0.0
            i.proteinToday = 0.0
            i.fatToday = 0.0
            i.fiberToday = 0.0
            i.saltToday = 0.0
            i.carbohydratesToday = 0.0
        }
        if i.firstItemDay{
            self.eatenToday.startTime = Date()
            i.proteinToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.protein) ?? 0.0) / 100)
            i.sugarToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.sugar) ?? 0.0) / 100)
            i.fatToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.fat) ?? 0.0) / 100)
            i.fiberToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.fiber) ?? 0.0) / 100)
            i.saltToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.salt) ?? 0.0) / 100)
            i.carbohydratesToday  += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.carb) ?? 0.0)  / 100)
            i.firstItemDay = false
            print("no working")
            
        }
        
        else {
           i.proteinToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.protein) ?? 0.0) / 100)
           i.sugarToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.sugar) ?? 0.0) / 100)
           i.fatToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.fat) ?? 0.0) / 100)
           i.fiberToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.fiber) ?? 0.0) / 100)
           i.saltToday += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.salt) ?? 0.0) / 100)
           i.carbohydratesToday  += ((Double(self.amounteaten ) ?? 1.0) * (Double(self.carb) ?? 0.0)  / 100)
            print("working")
        }
        
    }
}

struct ProductNotFound_Previews: PreviewProvider {
    static var previews: some View {
        ProductNotFound(showSelf: .constant(true))
    }
}
