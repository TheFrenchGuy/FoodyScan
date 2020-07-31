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
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var QRviewModel = ScannerViewModel()
    @Binding var showSelf:Bool
    @ObservedObject var getData = JSONParserFood()
    @State var amounteaten = ""
    
    
    @State var color = Color.black.opacity(0.5)
    var format = "%g"
    var body: some View {
        ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                ZStack(alignment: .topLeading) {
                    
                    VStack {
                    
                    VStack {
                        HStack(alignment: .top, spacing: 10) {
                            AnimatedImage(url: URL(string: self.getData.image_front_small_url))
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle()).shadow(radius: 20)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(getData.brands)")
                                Text("\(getData.product_name)")
                                Text("Product size: \(getData.product_quantity) grams")
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
                                Text("Energy: \(getData.energykcal_100g, specifier: self.format) Kcal")
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
                        .foregroundColor(Color("Color").opacity(0.7))
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
                        TextField("Roughly Amount Eaten in grams", text: self.$amounteaten) //Input the email address
                        .keyboardType(.numberPad)
                            .onReceive(Just(amounteaten)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.amounteaten = filtered
                                }
                        }
                        .padding()
                            .background(RoundedRectangle(cornerRadius: 25).stroke(self.amounteaten != "" ? Color("Color") : self.color,lineWidth: 2))
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }.padding(10)
                        
                        
                      Spacer()
                        VStack {
                            Button(action: {
                                self.addlist()
                                self.showSelf = false
                                self.QRviewModel.lastQrCode = ""
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
    func addlist() {
        let i = ListProduct(context: self.managedObjectContext)
        i.productID = UUID()
        i.brands = self.getData.brands
        
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
    
    //var url1 = "737628064502"  Debug purpouse to test information returned
    //var url2 = "5032439100179" Both of these are item codes with information used for debug only
    
    @ObservedObject var QRviewModel = ScannerViewModel()
    
    init(){
        let QRcode:String? = self.QRviewModel.lastQrCode //Redecleration to make the variable option refer to later documentation
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: "https://world.openfoodfacts.org/api/v0/product/\(QRcode ?? "NotScanned")")!) { (data, res, err) in
            
            //"NotScanned" neccessary when the user first init the scan as the view will be loaded without data which cause app to crash
            //State from which URL the data should be fetched, with then end changing based on the product scan.
            guard let data = data else {return}
            do{
                let fetch = try JSONDecoder().decode(WorldOpenFoodFacts.self, from: data)
                //Let the fetched data be stored under a variable to more easily pull out the data
                //self.jsonData = fetch
                DispatchQueue.main.async {
                    self.product_name = fetch.product.product_name ?? fetch.product.product_name_fr
                    self.brands = fetch.product.brands//gets the category outlined above
                    self.image_front_small_url = fetch.product.image_front_small_url
                    self.categories = fetch.product.categories
                    self.brand_owner_imported = fetch.product.brand_owner_imported ?? "Brand unknown"
                    self.product_quantity = fetch.product.product_quantity ?? 0
                    self.sugars_100g = fetch.product.nutriments.sugars_100g
                    self.energykcal_100g = fetch.product.nutriments.energykcal_100g
                    self.fat_100g = fetch.product.nutriments.fat_100g
                    self.fiber_100g = fetch.product.nutriments.fiber_100g
                    self.proteins_100g = fetch.product.nutriments.proteins_100g
                    self.salt_100g = fetch.product.nutriments.salt_100g
                    self.carbohydrates_100g = fetch.product.nutriments.carbohydrates_100g
                    
                    
                    print("Data has been fetched ") //Confirmation on the device side that the information has been fetched
                }
            }catch{
                print(error.localizedDescription) //In case the information is missing the error is printed for debug
            }
                        
        }.resume() //Needed to initiation the data Task.
    }
}


struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
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

