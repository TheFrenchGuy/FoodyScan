//
//  ProductInfoView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//
 
import SwiftUI
import SDWebImageSwiftUI //Added SDWebImage Package to the project in order to display the image from the JSON fetch to the UI
import Combine // Just publisher requires to import Combine.

struct ProductInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext //Neccessary in order to store the scanned products into CoreData Stcak
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var QRviewModel = ScannerViewModel() //Where the QRcode is gotten
    @ObservedObject var eatenToday = EatenToday()
    @Binding var showSelf:Bool //Whever or not to show the Scanner Views
    @ObservedObject var getData = JSONParserFood() //Where the data is fetched from so can be reference into the main view for user feedback
    @State var amounteaten = "" //Used laster for the calculation of the user
    @State var scanDate = Date()
    @State var showScan = UserDefaults.standard.value(forKey: "showScan") as? Bool ?? false //Whever the scanner view should be shown after being triggered from a shortcut
    //Variables used to make the UI Nicer
    @State var color = Color.black.opacity(0.5) //So when you time the amounteaten it changes color
    var format = "%g" //So that it doesnt not show any zeros after the decimal point
    
    
    var body: some View {
        ZStack {
               Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                if self.getData.statusVerbose == "product found" {
                    ZStack(alignment: .topLeading) {
                        ScrollView {
                            
                            VStack {
                            
                                VStack {
                                    HStack(alignment: .top, spacing: 10) {
                                        if self.getData.image_front_small_url != "No image" {
                                        AnimatedImage(url: URL(string: self.getData.image_front_small_url)) //Gotten from the imported SDWebImageSwiftUI
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle()).shadow(radius: 20)
                                            .padding()
                                        } else {
                                            Image(systemName: "bag.fill")
                                            .resizable()
                                            .frame(width: 60, height: 70)
                                           // .clipShape(Circle()).shadow(radius: 20)
                                            .padding()
                                        }
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("\(getData.brands)")
                                                .bold()
                                            Text("\(getData.product_name)")
                                                .bold()
                                            Text(getData.statusVerbose.capitalizingFirstLetter())
                                               
                                        }
                                    }
                                    .foregroundColor(self.colorScheme == .light ? Color.colorDark: Color.colorLight) //Inverted the colors as it looked better that way on the green background
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 20)
                                
                                
                                }
                                .background(LinearGradient(gradient: Gradient(colors: [.gradientStartDark, .gradientEndDark]), startPoint: .leading, endPoint: .trailing))
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
                                            Text("Sugar: \(getData.sugars_100g, specifier: self.format) grams")
                                        }
                                        
                                        HStack {
                                            Image("Energy")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            Text("Energy: \(getData.energykcal_100g) Kcal")
                                        }
                                        
                                        HStack {
                                            Image("Carbohydrates")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                        Text("Carb: \(getData.carbohydrates_100g, specifier: self.format) grams")
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
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                                

                                
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .center) {
                                                Image("Fat")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                Text("Fat: \(getData.fat_100g, specifier: self.format) grams")
                                            }
                                            
                                            HStack(alignment: .center) {
                                                Image("Fiber")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                Text("Fiber: \(getData.fiber_100g, specifier: self.format) grams")
                                            }
                                            
                                            HStack(alignment: .center) {
                                                Image("Protein")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                Text("Protein: \(getData.proteins_100g, specifier: self.format) grams")
                                            }
                                            
                                            HStack(alignment: .center) {
                                                Image("Salt")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                Text("Salt: \(getData.salt_100g, specifier: self.format) grams")
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
                                .onTapGesture {
                                    self.hideKeyboard()
                                }

                                
                            VStack {
                                Text(getData.categories)
                                .foregroundColor(Color("Color"))
                            }
                                
                                
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
                                        self.goHome()
                                        self.QRviewModel.lastQrCode = "" //Clears the QRCode so can start again
                                        self.userSettings.eatentoday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.energykcal_100g) / 100)
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
                else if self.getData.statusVerbose == "product not found" {
                    ProductNotFound(showSelf: $showSelf) //Sends to a seperate view if the product is not found
                }
                else { //So when the JSON request is running the user is greeted with a loading screen
                    VStack {
                        
                        GradientText(title: "Loading", size: 32, width: Int(UIScreen.main.bounds.width - 250))
                        LottieView(filename: "fruitloaderlottie", speed: 1, loop: .loop).frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.3)
                        
                        if self.getData.error {
                            Spacer()
                            
                            Button(action: {
                                self.showSelf = false //Returns to the homeview
                                self.goHome()
                                self.QRviewModel.lastQrCode = "" //Clears the QRCode so can start again
                            }) {
                                Text("Error")
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
                        }
                    }
            }
        }
//        .onTapGesture {
//                self.hideKeyboard()
//        }
    }
    func addlist() { //Used to store the scan result into CoreData so can be later used for the pastScan views
        let i = ListProduct(context: self.managedObjectContext)
        i.productID = UUID() //Neccessary in order so that each of the product have a unique ID so can be shown in the list
        i.scanDate = self.scanDate
        //Rest of the variables used for the list
        i.brands = self.getData.brands
        i.brand_owner_imported  = self.getData.brand_owner_imported
        i.product_name = self.getData.product_name
        i.image_front_small_url = self.getData.image_front_small_url
        i.categories = self.getData.categories
        i.sugars_100g = self.getData.sugars_100g
        i.energykcal_100g = Int16(self.getData.energykcal_100g)
        i.fat_100g = self.getData.fat_100g
        i.fiber_100g = self.getData.fiber_100g
        i.proteins_100g = self.getData.proteins_100g
        i.salt_100g = self.getData.salt_100g
        i.carbohydrates_100g = self.getData.carbohydrates_100g
        i.amountEaten = Int16(self.amounteaten) ?? Int16(1)
        let amounteaten = Double(self.amounteaten)
        i.sugarIn = ((amounteaten ?? 1.0) / 100 ) * self.getData.sugars_100g
        i.energyInKcal = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.energykcal_100g)
        
        i.proteinIn = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.proteins_100g)
        i.fatIn = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.fat_100g)
        i.fiberIn = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.fiber_100g)
        i.saltIn = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.salt_100g)
        i.carbohydratesIn = ((amounteaten ?? 1.0) / 100 ) * Double(self.getData.carbohydrates_100g)
        
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
            i.proteinToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.proteins_100g) / 100)
            i.sugarToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.sugars_100g) / 100)
            i.fatToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.fat_100g) / 100)
            i.fiberToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.fiber_100g) / 100)
            i.saltToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.salt_100g) / 100)
            i.carbohydratesToday  += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.carbohydrates_100g  / 100))
            i.firstItemDay = false
            print("no working")
            
        }
        
        else {
            i.proteinToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.proteins_100g) / 100)
            i.sugarToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.sugars_100g) / 100)
            i.fatToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.fat_100g) / 100)
            i.fiberToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.fiber_100g) / 100)
            i.saltToday += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.salt_100g) / 100)
            i.carbohydratesToday  += ((Double(self.amounteaten ) ?? 1.0) * Double(self.getData.carbohydrates_100g / 100))
            print("working")
        }
        
    }
    
    func goHome() { //So the user can go back to the main screen when he has finsihed to scan his product
        UserDefaults.standard.set(false, forKey: "showScan") //Sets the status to be true and stored in memory so next app launch the user wont have to login
        NotificationCenter.default.post(name: NSNotification.Name("showScan"), object: nil)
    }
}

struct ProductInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoView(showSelf: .constant(true))
        
        
    }
}



class JSONParserFood: ObservableObject {
    @Published var jsonData : WorldOpenFoodFacts! //State the dataset used
    @Published var product_name = ""
    @Published var image_front_small_url = ""
    @Published var brands = ""
    @Published var categories = ""
    @Published var product_quantity = 0
    @Published var brand_owner_imported = ""
    @Published var sugars_100g = 0.0
    @Published var energykcal_100g = 0
    @Published var fat_100g = 0.0
    @Published var fiber_100g = 0.0
    @Published var proteins_100g = 0.0
    @Published var salt_100g = 0.0
    @Published var carbohydrates_100g = 0.0
    @Published var statusVerbose = ""
    @Published var error:Bool = false
    
    //var url1 = "737628064502"  Debug purpouse to test information returned
    //var url2 = "5032439100179" Both of these are item codes with information used for debug only
    
    @ObservedObject var QRviewModel = ScannerViewModel()
    
    init(){
        let QRcode:String? = self.QRviewModel.lastQrCode //Redecleration to make the variable option refer to later documentation
        let session = URLSession(configuration: .default)
        print(QRcode as Any)
        //print(session.dataTask(with: URL(string: "https ://world.openfoodfacts.org/api/v0/product/\(QRcode ?? "NotScanned")")!))
        session.dataTask(with: URL(string: "https://world.openfoodfacts.org/api/v0/product/\(QRcode ?? "NotScanned")")!) { (data, res, err) in
            
            //"NotScanned" neccessary when the user first init the scan as the view will be loaded without data which cause app to crash
            //State from which URL the data should be fetched, with then end changing based on the product scan.
            guard let data = data else {return}
            do{
                let fetch = try JSONDecoder().decode(WorldOpenFoodFacts.self, from: data)
                //Let the fetched data be stored under a variable to more easily pull out the data
                //self.jsonData = fetch
                DispatchQueue.main.async { //All have alternative value so that the app won't crash if any are missing
                    self.statusVerbose = fetch.statusVerbose
                    self.product_name = fetch.product.product_name ?? fetch.product.product_name_fr
                    self.brands = fetch.product.brands ?? "Unknown Brand"//gets the category outlined above
                    self.image_front_small_url = fetch.product.image_front_small_url ?? "No image"
                    self.categories = fetch.product.categories ?? "Unknown Category"
                    self.brand_owner_imported = fetch.product.brand_owner_imported ?? "Brand unknown"
                    self.sugars_100g = fetch.product.nutriments.sugars_100g ?? 0.0
                    self.energykcal_100g = fetch.product.nutriments.energykcal_100g ?? 0
                    self.fat_100g = fetch.product.nutriments.fat_100g ?? 0.0
                    self.fiber_100g = fetch.product.nutriments.fiber_100g ?? 0.0
                    self.proteins_100g = fetch.product.nutriments.proteins_100g ?? 0.0
                    self.salt_100g = fetch.product.nutriments.salt_100g ?? 0.0
                    self.carbohydrates_100g = fetch.product.nutriments.carbohydrates_100g ?? 0.0
                    
                    print("Data has been fetched ") //Confirmation on the device side that the information has been fetched
                }
            }catch{
                print(error)//In case the information is missing the error is printed for debug
            }
                        
        }.resume() //Needed to initiation the data Task.
    }
}


struct BlurView: UIViewRepresentable { //So that it gives a blur effect behind one view
    //Uses UIViewRepresentable in order to link between UIKit and Swift UI
    typealias UIViewType = UIVisualEffectView //Defines the view type
    
    let style: UIBlurEffect.Style //The desired effect
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}



extension String {
    func capitalizingFirstLetter() -> String { //To make the JSON string gotten form the fetch look nicer
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() { //So that the first letter of the JSON string is capitalised
        self = self.capitalizingFirstLetter()
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() { //In order to hide the  keyboard when the user has finished typing the number of calories
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
