//
//  ProductInfoModel.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 28/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation


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
    let product_name: String!
    let product_name_fr: String! //The name of the product
    let image_front_small_url : String! //The image of the product
    let categories : String! //What kind of product it is
    let brands: String!
    let nutriments: nutriments

    //More information can be added later on
    enum CodingKeys: String, CodingKey { //These are decalred so later they can be found using the JSON deserialiser
        case brand_owner_imported = "brand_owner_imported"
        case product_name = "product_name"
        case product_name_fr = "product_name_fr"
        case image_front_small_url = "image_front_small_url"
        case categories = "categories"
        case brands = "brands"
        case nutriments
    }
    
}

struct nutriments: Decodable, Hashable {
    let sugars_100g: Double!
    let energy_100g: Int!
    
    
    enum CodingKeys: String, CodingKey {
        
        case sugars_100g = "sugars_100g"
        case energy_100g = "energy_100g"
    }
}
