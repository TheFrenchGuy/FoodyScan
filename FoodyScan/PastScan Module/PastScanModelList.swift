//
//  PastScanModelList.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 31/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

@objc(ListProduct)
public class ListProduct:NSManagedObject, Identifiable {
    @NSManaged var productID:UUID
    //@NSManaged var brand_owner_imported : String!
   // @NSManaged var product_name: String!
   // @NSManaged var product_name_fr: String! //The name of the product
   // @NSManaged var image_front_small_url : String! //The image of the product
   // @NSManaged var categories : String! //What kind of product it is
    @NSManaged var brands: String
    // @NSManaged var product_quantity: Int
}

extension ListProduct
{
    
    public static func fetchAllItems() ->NSFetchRequest<ListProduct>
    {
        let request:NSFetchRequest<ListProduct> = NSFetchRequest<ListProduct>(entityName: "ListProduct")
        request.shouldRefreshRefetchedObjects = true
        
        let sortDescriptor = NSSortDescriptor(key: "brands", ascending: true)

        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
