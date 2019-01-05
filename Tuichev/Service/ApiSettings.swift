//
//  ApiSettings.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

class ApiSettings {
    
    static let shared = ApiSettings()
    
    private init() {}
    
    let kServerBaseURL = "https://api.coinmarketcal.com/"
    
    private var currentDefaults: UserDefaults = .standard
    
    var token: String? {
        set {
            let value = newValue
            currentDefaults.set(value, forKey: Keys.token)
            currentDefaults.synchronize()
        }
        
        get {
            guard let value = currentDefaults.object(forKey: Keys.token) as? String else {
                return nil
            }
            
            return value.isEmpty ? nil : "Bearer " + value 
        }
    }
    
}
