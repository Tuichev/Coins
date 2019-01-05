//
//  InternetService.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation
import Reachability
import Alamofire

class InternetService {
    
    let reachability = Reachability()
    let net = NetworkReachabilityManager(host: "www.google.com")
    
    static let shared = InternetService()
    var internetHandler: ((_ flag: Bool) -> Void)?
    
    private init() {
    }
    
    func start() {
        self.startNetworkReachabilityObserver()
    }
    
    private func startNetworkReachabilityObserver() {
        
        net?.listener = { status in
            //////////////////////
            switch status {
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                self.internetHandler?(true)
            case .notReachable:
                self.internetHandler?(false)
            default:
                print("smth wrong with connection")
            }
        }
        
        net?.startListening()
    }
    
    func checkInternetConnect() -> Bool {
        guard self.reachability?.connection != .none else {
            return false
        }
        
        return true
    }
}
