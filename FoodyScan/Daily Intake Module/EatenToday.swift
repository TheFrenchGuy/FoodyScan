//
//  EatenToday.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 11/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import SwiftUI


class EatenToday: ObservableObject {
    
    @Published var firstItemDay: Bool {
        didSet {
            UserDefaults.standard.set(firstItemDay, forKey: "firstItemDay")
        }
    }
    @Published var startTime: Date {
        didSet {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        }
    }
    
    @Published var sugarToday: Double {
        didSet {
            UserDefaults.standard.set(sugarToday, forKey: "sugarToday")
        }
    }
    
    @Published var proteinToday: Double {
        didSet {
            UserDefaults.standard.set(proteinToday, forKey: "proteinToday")
        }
    }
    
    @Published var fatToday: Double {
        didSet {
            UserDefaults.standard.set(fatToday, forKey: "fatToday")
        }
    }
    
    @Published var fiberToday: Double {
        didSet {
            UserDefaults.standard.set(fiberToday, forKey: "fiberToday")
        }
    }
    
    @Published var saltToday: Double {
        didSet {
            UserDefaults.standard.set(saltToday, forKey: "saltToday")
        }
    }
    
    @Published var carbohydratesToday: Double {
        didSet {
            UserDefaults.standard.set(carbohydratesToday, forKey: "carbohydratesToday")
        }
    }
    
    
    
    
    
    init() {
        self.firstItemDay = UserDefaults.standard.object(forKey: "firstItemDay") as? Bool ?? true
        self.startTime = UserDefaults.standard.object(forKey: "startTime") as? Date ?? Date()
        self.sugarToday = UserDefaults.standard.object(forKey: "sugarToday") as? Double ?? 1.0
        self.proteinToday = UserDefaults.standard.object(forKey: "proteinToday") as? Double ?? 1.0
        
        self.fatToday = UserDefaults.standard.object(forKey: "fatToday") as? Double ?? 1.0
        
        self.fiberToday = UserDefaults.standard.object(forKey: "fiberToday") as? Double ?? 1.0
        
        self.saltToday = UserDefaults.standard.object(forKey: "saltToday") as? Double ?? 1.0
        
        self.carbohydratesToday = UserDefaults.standard.object(forKey: "carbohydratesToday") as? Double ?? 1.0
    }
}
