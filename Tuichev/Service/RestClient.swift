//
//  RestClient.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation
import Alamofire

class RestClient: NSObject {
    
    static let shared = RestClient()
    private var http = HttpService()
    
    let baseUrl = ApiSettings.shared.kServerBaseURL
    
    override init() {
        super.init()
    }
    
    func getToken(resp: @escaping IdResponseBlock) {
        
        let url = baseUrl + Requests.token
        
        let params: [String: Any] = ["grant_type": StringValue.kGrantType,
                                     "client_id": StringValue.kClientId,
                                     "client_secret": StringValue.kClientSecret]
        
        http.query(url, method: .get, parameters: params, queue: .defaultQos, resp: { (respData, error) in
            
            if let err = error {
                return resp(nil, err)
            }
            
            guard let data = respData as? [String: Any], let token = data["access_token"] else {
                return resp(nil, error)
            }
            
            return resp(token, nil)
        })
    }
    
    func getEvents(page: Int = 1, resp: @escaping IdResponseBlock) {
        
        let url = baseUrl + Requests.events
        
        let params: [String: Any] = ["page": page]
        
        http.queryBy(url, method: .get, parameters: params, queue: .defaultQos, resp: { (respData, error) in
            
            if let err = error {
                return resp(nil, err)
            }
            
            guard let data = respData as? Data, let product = try? JSONDecoder().decode([Event].self, from: data) else {
                return resp(nil, error)
            }
            
            return resp(product, nil)    
        })
    }
    
}

