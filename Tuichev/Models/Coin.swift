//
//  Coin.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

struct Coin: Codable {
    
    var id: String?
    var name: String?
    var symbol: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
    }
}
