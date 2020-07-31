//
//  PastScansView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 31/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI

struct PastScansView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ListProduct.fetchAllItems()) var products: FetchedResults<ListProduct>
    
    var body: some View {
        VStack {
            List {
                ForEach(self.products) {
                    i in
                    
                    HStack {
                        Text(i.brands)
                    }
                }
            }
        }
    }
}

struct PastScansView_Previews: PreviewProvider {
    static var previews: some View {
        PastScansView()
    }
}
