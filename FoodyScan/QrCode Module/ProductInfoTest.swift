//
//  ProductInfoTest.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 28/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct ProductInfoTest: View {
    
     @ObservedObject var getData = datas()
    @ObservedObject var viewModel = ScannerViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProductInfoTest_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoTest()
    }
}

struct WorldOpenFoodFacts: Decodable{
    let status: Int //Whever the product is found in the database
    let code, statusVerbose: String
    let product: Product // the information about the product including sugar and energy information

    enum CodingKeys: String, CodingKey { //State them so they can be deserialised from the JSON parser
        case status, code
        case statusVerbose = "status_verbose"
        case product
    }
}

struct Product: Decodable, Hashable, Identifiable{ //Listed underneath is the multiple information we want to get from the product
    let id = UUID().uuidString //Item number which should be the same as the QR code scan
    let brand_owner_imported : String!
    let generic_name : String! //The name of the product
    let image_front_small_url : String! //The image of the product
    let categories : String! //What kind of product it is
    //More information can be added later on
    enum CodingKeys: String, CodingKey { //These are decalred so later they can be found using the JSON deserialiser
        case brand_owner_imported = "brand_owner_imported"
        case generic_name = "generic_name"
        case image_front_small_url = "image_front_small_url"
        case categories = "categories"
    }
    
}

class datas: ObservableObject {
    @Published var jsonData : WorldOpenFoodFacts! //State the dataset used
    @Published var name = ""
    @Published var image_front_small_url = ""
    @State var url1 = "737628064502" // Debug purpouse to test information returned
    @State var url2 = ScannerViewModel().lastQrCode// Both of these are item codes with information
    @State var something = true
    
    init(){
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: "https://world.openfoodfacts.org/api/v0/product/\(url2)")!) { (data, res, err) in
            //State from which URL the data should be fetched, with then end changing based on the product scan.
            guard let data = data else {return}
            do{
                let fetch = try JSONDecoder().decode(WorldOpenFoodFacts.self, from: data)
                //Let the fetched data be stored under a variable to more easily pull out the data
                //self.jsonData = fetch
                DispatchQueue.main.async {
                    self.name = fetch.product.categories //gets the category outlined above
                    self.image_front_small_url = fetch.product.image_front_small_url // ''
                    print("Data has been fetched ") //Confirmation on the device side that the information has been fetched
                }
            }catch{
                print(error.localizedDescription) //In case the information is missing the error is printed for debug
            }
                        
        }.resume() //Needed to initiation the dataTask.
    }
}

struct ListRow: View {
    var url: String
    var name: String
    
    var body: some View{
        
            Text(name).fontWeight(.heavy).padding(.leading, 10)
            
            
        }
    }





