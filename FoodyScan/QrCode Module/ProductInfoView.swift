//
//  ProductInfoView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//
 
import SwiftUI
import SDWebImageSwiftUI //Added SDWebImage Package to the project in order to display the image from the JSON fetch to the UI
import Combine // Just publisher requires to import Combine.\
struct ProductInfoView: View {
    @Environment(\.managedObjectContext) var managedObjectContext //Neccessary in order to store the scanned products into CoreData Stcak
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var QRviewModel = ScannerViewModel() //Where the QRcode is gotten
    @Binding var showSelf:Bool //Whever or not to show the Scanner Views
    @ObservedObject var getData = JSONParserFood() //Where the data is fetched from so can be reference into the main view for user feedback
    @State var amounteaten = "" //Used laster for the calculation of the user
    @State var scanDate = Date()
    
    //Variables used to make the UI Nicer
    @State var color = Color.black.opacity(0.5) //So when you time the amounteaten it changes color
    var format = "%g" //So that it doesnt not show any zeros after the decimal point
    
    
    var body: some View {
        ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                ZStack(alignment: .topLeading) {
                    
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
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 20)
                    
                    
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .padding(.top, 25)
                    
                    
                    VStack {
                        
                        HStack {
                            VStack {
                                Text("For 100g: ")
                                    .bold()
                                Text("Sugar: \(getData.sugars_100g, specifier: self.format) grams")
                                Text("Energy: \(getData.energykcal_100g) Kcal")
                                Text("Carb: \(getData.carbohydrates_100g, specifier: self.format) grams")
                             
                            }
                            Divider().frame(width: 20, height: 30)
                            VStack {
                                Text("Fat: \(getData.fat_100g, specifier: self.format) grams")
                                Text("Fiber: \(getData.fiber_100g, specifier: self.format) grams")
                                Text("Protein: \(getData.proteins_100g, specifier: self.format) grams")
                                Text("Salt: \(getData.salt_100g, specifier: self.format) grams")
                            }
                        }
                        .foregroundColor(Color("Color"))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        }
                    .background(BlurView())
                    //.background(Color("Color"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .padding(.top, 5)
                        
                    VStack {
                        Text(getData.categories)
                        .foregroundColor(Color("Color"))
                    }
                        
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
                            .background(RoundedRectangle(cornerRadius: 25).stroke(self.amounteaten != "" ? Color("Color") : self.color,lineWidth: 2)) //Changes the color when the user inputs into  the text field
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }.padding(10)
                        
                        
                      Spacer()
                        VStack {
                            Button(action: {
                                self.addlist() //Sves the data to the CoreData stack
                                self.showSelf = false //Returns to the homeview
                                self.QRviewModel.lastQrCode = "" //Clears the QRCode so can start again
                                self.userSettings.eatentoday += Double(self.amounteaten) ?? 1.0
                            }) {
                                Text("Add to list")
                                .fontWeight(.light)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 80)
                                .background(Color("Color"))
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
        do {
            try self.managedObjectContext.save()
            print("Product Added to list")
        }catch {
            print("error inserting list")
        }
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
    
    //var url1 = "737628064502"  Debug purpouse to test information returned
    //var url2 = "5032439100179" Both of these are item codes with information used for debug only
    
    @ObservedObject var QRviewModel = ScannerViewModel()
    
    init(){
        let QRcode:String? = self.QRviewModel.lastQrCode //Redecleration to make the variable option refer to later documentation
        let session = URLSession(configuration: .default)
        print(QRcode as Any)
        print(session.dataTask(with: URL(string: "https://world.openfoodfacts.org/api/v0/product/\(QRcode ?? "NotScanned")")!))
        session.dataTask(with: URL(string: "https://world.openfoodfacts.org/api/v0/product/\(QRcode ?? "NotScanned")")!) { (data, res, err) in
            
            //"NotScanned" neccessary when the user first init the scan as the view will be loaded without data which cause app to crash
            //State from which URL the data should be fetched, with then end changing based on the product scan.
            guard let data = data else {return}
            do{
                let fetch = try JSONDecoder().decode(WorldOpenFoodFacts.self, from: data)
                //Let the fetched data be stored under a variable to more easily pull out the data
                //self.jsonData = fetch
                DispatchQueue.main.async {
                    self.statusVerbose = fetch.statusVerbose
                    self.product_name = fetch.product.product_name ?? fetch.product.product_name_fr
                    self.brands = fetch.product.brands//gets the category outlined above
                    self.image_front_small_url = fetch.product.image_front_small_url ?? "No image"
                    self.categories = fetch.product.categories
                    self.brand_owner_imported = fetch.product.brand_owner_imported ?? "Brand unknown"
                    self.sugars_100g = fetch.product.nutriments.sugars_100g ?? 1.0
                    self.energykcal_100g = fetch.product.nutriments.energykcal_100g //?? 1
                    self.fat_100g = fetch.product.nutriments.fat_100g ?? 1.0
                    self.fiber_100g = fetch.product.nutriments.fiber_100g ?? 1.0
                    self.proteins_100g = fetch.product.nutriments.proteins_100g ?? 1.0
                    self.salt_100g = fetch.product.nutriments.salt_100g ?? 1.0
                    self.carbohydrates_100g = fetch.product.nutriments.carbohydrates_100g ?? 1.0
                    
                    print(self.image_front_small_url)
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
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
