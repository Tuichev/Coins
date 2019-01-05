//
//  DateFormatter.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case userDate = "yyyy-MM-dd"
    case serverDateTime = "YYYY-MM-dd'T'HH:mm:ss+HH:mm"
}

class DateFormat {
    
    static let shared = DateFormat()
    private init() {}
    
    let dateFormatter = DateFormatter()
    
    func forrmatedStringDate(str: String) -> String {
      
        dateFormatter.dateFormat = DateFormatType.serverDateTime.rawValue
        
        guard let dateObj = dateFormatter.date(from: str) else {
            return ""
        }
        
        dateFormatter.dateFormat = DateFormatType.userDate.rawValue
     
        return dateFormatter.string(from: dateObj)
    }
    
}
