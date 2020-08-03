//
//  PastScanModelList.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 31/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import CoreData //How the data is being stored
import SwiftUI

@objc(ListProduct)
public class ListProduct:NSManagedObject, Identifiable {
    @NSManaged var productID:UUID // So that all of the items have a unique id so they can all be stored on the device storage without being overwriten
    @NSManaged var brands: String!
    @NSManaged var brand_owner_imported: String!
    @NSManaged var product_name: String!
    @NSManaged var image_front_small_url: String!
    @NSManaged var categories: String!
    @NSManaged var product_quantity: Int16 //Used Int16 because it has a max value of 65536, so should be more than enough
    @NSManaged var sugars_100g: Double
    @NSManaged var energykcal_100g: Int16
    @NSManaged var fat_100g: Double
    @NSManaged var fiber_100g: Double
    @NSManaged var proteins_100g: Double
    @NSManaged var salt_100g: Double
    @NSManaged var carbohydrates_100g: Double
    @NSManaged var scanDate: Date // So that the scan can be sorted from the newest to the latest
    
    
    @NSManaged var amountEaten: Int16
    @NSManaged var energyInKcal: Double
    @NSManaged var sugarIn: Double
}

extension ListProduct
{
    
    public static func fetchAllItems() ->NSFetchRequest<ListProduct> //Requered to fetch all of the item from memory
    {
        let request:NSFetchRequest<ListProduct> = NSFetchRequest<ListProduct>(entityName: "ListProduct") //Defines what to request and what is the name of the entiyy also defined in the xcdatamodelID
        request.shouldRefreshRefetchedObjects = true
        
        let sortDescriptor = NSSortDescriptor(key: "scanDate", ascending: false) //In what way the data is sorted

        request.sortDescriptors = [sortDescriptor]
        return request //Returns the request so that it can be processed
    }
}
