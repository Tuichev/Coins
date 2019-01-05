//
//  AppManager.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

class AppManager: NSObject {
    
    static let shared = AppManager()
    
    //TODO: add checking for token expiration
    func checkToken() {
        
        if ApiSettings.shared.token == nil {
            
            RestClient.shared.getToken(resp: {[weak self] _,_ in })          
        }
    }
    
}
