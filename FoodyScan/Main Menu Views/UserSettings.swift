//
//  UserSettings.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 25/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import Foundation
import Combine

class UserSettings: ObservableObject { //Class used to store user settings
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
    
    public var genders = ["Male", "Female", "Other"] //Necessary for the picker in the daily intake calculator view
    
    @Published var activitylevel: Int {
        didSet {
            UserDefaults.standard.set(activitylevel, forKey: "activitylevel")
        }
    }
    
    @Published var birthdate: Date {
        didSet {
            UserDefaults.standard.set(birthdate, forKey: "birthdate")
        }
    }
    
    @Published var dailyintakekcal: Double {
        didSet {
            UserDefaults.standard.set(dailyintakekcal, forKey: "dailyintakekcal")
        }
    }
    
    init() { //Creates default values for the app and allows the class to be initialaised
        self.height = UserDefaults.standard.object(forKey: "height") as? Double ?? 1.0
        self.weight = UserDefaults.standard.object(forKey: "weight") as? Double ?? 1.0
        self.gender = UserDefaults.standard.object(forKey: "gender") as? String ?? "Other"
        self.activitylevel = UserDefaults.standard.object(forKey: "activitylevel") as? Int ?? 1
        self.birthdate = UserDefaults.standard.object(forKey: "birthdate") as? Date ?? Date()
        self.dailyintakekcal = UserDefaults.standard.object(forKey: "dailyintakekcal") as? Double ?? 1000.0
    }
}

