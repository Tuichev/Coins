//
//  BasePresenter.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

class BasePresenter {
    
    //bad way for logo, but i didn't find another url except 'proof'
    func getImageUrl(_ coinId: String) -> String {
        return "https://d235dzzkn2ryki.cloudfront.net/\(coinId)_normal.png"
    }
    
    func getCoinsName(_ coins: [Coin]?) -> String {
        
        var labelText: [String] = []
        coins?.forEach( { labelText.append($0.name ?? "") } )
        
        return labelText.joined(separator:",")
    }
    
}
