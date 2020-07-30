//
//  ProductInfoView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 26/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//
 
import SwiftUI

struct ProductInfoView: View {
    
     @ObservedObject var QRviewModel = ScannerViewModel()
     @Binding var showSelf:Bool
     @ObservedObject var getData = JSONParserFood()
    
    var body: some View {
            VStack {
                Text("\(self.QRviewModel.lastQrCode)")
                    
                Button(action: {
                    self.showSelf = false
                    self.QRviewModel.lastQrCode = ""
                }) {
                    Text("Go home")
                }
                
                Text(getData.brands + " " + getData.name)
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
    @Published var name = ""
    @Published var image_front_small_url = ""
    @Published var brands = ""
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
                    self.name = fetch.product.product_name ?? fetch.product.product_name_fr
                    self.brands = fetch.product.brands//gets the category outlined above
                    self.image_front_small_url = fetch.product.image_front_small_url // ''
                    print("Data has been fetched ") //Confirmation on the device side that the information has been fetched
                }
            }catch{
                print(error.localizedDescription) //In case the information is missing the error is printed for debug
            }
                        
        }.resume() //Needed to initiation the data Task.
    }
}
