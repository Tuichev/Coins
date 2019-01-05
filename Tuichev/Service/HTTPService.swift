//
//  HTTPService.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation
import Alamofire

typealias IdResponseBlock = (_ swiftObj: Any?, _ error: Error?) -> Void

protocol CustomErrorProtocol: Error {
    var localizedDescription: String { get }
    var code: Int { get }
}

enum QueueQos {
    case background
    case defaultQos
}

struct CustomError: CustomErrorProtocol {
    
    var localizedDescription: String
    var code: Int
    
    init(localizedDescription: String, code: Int) {
        self.localizedDescription = localizedDescription
        self.code = code
    }
}

class HttpService {
    
    func checkInternetConnect() -> Bool {
        return InternetService.shared.checkInternetConnect()
    }
    
    func internetConnectErr() -> CustomError {
        return CustomError(localizedDescription: "No internet connection", code: 404)
    }
    
    func requestError(_ description: String?, _ error: Int?) -> CustomError {
        return CustomError(localizedDescription: description ?? "Something went wrong.", code: error ?? 404)
    }
    
}

extension HttpService {
    
    func cancellAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func queryBy(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 queue: QueueQos,
                 headers: HTTPHeaders? = nil,
                 resp: @escaping IdResponseBlock) {
        
        guard let token = ApiSettings.shared.token else {
            return resp(nil, requestError(nil , nil))
        }
        
        var headersForQuery: HTTPHeaders = headers ?? [Keys.token: token]
        headersForQuery[Keys.token] = token
        
        return query(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headersForQuery,
                     queue: queue,
                     resp: resp)
    }
    
    func queryWithoutTokenBy (_ url: URLConvertible,
                                 method: HTTPMethod = .get,
                                 parameters: Parameters? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default,
                                 headers: HTTPHeaders? = nil,
                                 queue: QueueQos,
                                 resp: @escaping IdResponseBlock) {
        
        query(url,
              method: method,
              parameters: parameters,
              encoding: encoding,
              headers: headers,
              queue: queue,
              resp: resp)
        
    }
    
    internal func query(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        queue: QueueQos,
                        resp: @escaping IdResponseBlock) {
        
        var queueQos = DispatchQueue(label: "com.LoftSoft-queueBackground", qos: .background, attributes: [.concurrent])
        
        switch queue {
        case QueueQos.defaultQos:
            queueQos = DispatchQueue(label: "com.LoftSoft-queueDefault", qos: .default, attributes: [.concurrent])
        default:
            break
        }
        
        if !checkInternetConnect() {
            return resp(nil, internetConnectErr())
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: encoding,
                                        headers: headers
            ).responseJSON (queue: queueQos) { (response) in
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                switch response.result {
                case .success:
                    
                    if let respValue = response.result.value {
                        guard let jsonResp = try? JSONSerialization.data(withJSONObject: respValue, options: []), let jResp = (try? JSONSerialization.jsonObject(with: jsonResp)) else { return }
                        
                        if let dict = jResp as? [String: Any] {
                            
                            let status = dict["status"] as? String
                            
                            if status == "error" {
                                return resp(nil, self.requestError(nil , nil))
                            }
                            
                            if let accessToken = dict["access_token"] as? String {
                                ApiSettings.shared.token = accessToken
                            }
                            
                        } else if let arrayDict = jResp as? [[String: Any]] {
                            
                            print(arrayDict)
                        }
                        
                        if let err =  self.parseErrors(jsonResp) {
                            return resp(nil, err)
                        }
                        
                        resp(jsonResp, nil)
                    }
                    
                    break
                case .failure:
                    if (response.error as NSError?)?.code == NSURLErrorCancelled {
                        print("request canceled")
                    } else {
                        resp(nil, self.requestError(nil , nil))
                    }
                }
        }
        print("Request================")
        print (request)
    }
    
    func parseErrors(_ jResp: Data) -> CustomError? {
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jResp) as? [String: Any] {
                
                if let errorShow = json["error_description"] as? String {
                    return CustomError(localizedDescription: errorShow, code: 400) //TODO parse code
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return nil
    }
    
}
