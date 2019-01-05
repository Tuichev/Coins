//
//  Event.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    var id: Int?
    var title: String?
    var coins: [Coin]?
    var logo: String?
    var description: String?
    var percentage: Int?
    var date: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case coins = "coins"
        case logo = "proof"//TODO
        case description = "description"
        case percentage = "percentage"
        case date = "date_event"
    }
}
