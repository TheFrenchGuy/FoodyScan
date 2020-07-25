//
//  UserSettings.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 25/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var height: Double {
        didSet {
            UserDefaults.standard.set(height, forKey: "height")
        }
    }
    
    @Published var weight: Double {
        didSet {
            UserDefaults.standard.set(weight, forKey: "weight")
        }
    }
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "gender")
        }
    }
    
    public var genders = ["Male", "Female", "Other"]
    
    @Published var activitylevel: String {
        didSet {
            UserDefaults.standard.set(activitylevel, forKey: "activitylevel")
        }
    }
    
    @Published var birthdate: Date {
        didSet {
            UserDefaults.standard.set(birthdate, forKey: "birthdate")
        }
    }
    
    init() {
        self.height = UserDefaults.standard.object(forKey: "height") as? Double ?? 1.0
        self.weight = UserDefaults.standard.object(forKey: "weight") as? Double ?? 1.0
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? "Other"
        self.activitylevel = UserDefaults.standard.object(forKey: "activitylevel") as? String ?? "What your activity level?"
        self.birthdate = UserDefaults.standard.object(forKey: "birthdate") as? Date ?? Date()
    }
}

