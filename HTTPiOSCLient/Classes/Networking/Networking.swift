//
//  Networking.swift
//  HTTPClient
//
//  Created by Nunzio Giulio Caggegi on 14/11/20.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

// enum used for convenience purposes (optional)
internal enum ServerURL: String {
    case base = "https://"
}

internal class RestClient {
    var baseURL: String
    var apiKey: String?
    
    var defaultHeader: HTTPHeaders = [
        "Content-Type": "application/json",
    ]
    
    private var initialized: Bool = false
    
    internal init(baseURL: ServerURL = .base) {
        self.baseURL = baseURL.rawValue
    }
    
    func setupBaseUrl(baseUrl: String) {
        initialized = true
        self.baseURL.append(baseUrl)
    }
    
    internal func request(_ method: HTTPMethod, URIString: String, parameters: [String:AnyObject]?, withQuery: Bool,
                 headers: HTTPHeaders = [:], localized: Bool = true) -> Promise < JSON > {
        
        if initialized == false {
            fatalError("YOU MUST CALL SETUP")
        }
        
        return Promise { prom in
            let header = defaultHeader
            var query: String = baseURL+URIString
            
            print("requestURL: \(query)")
            
            AF.request(query, method: method,
                              parameters: method == .get ? nil : parameters,
                              encoding: JSONEncoding.default,
                              headers: header).responseJSON { (response) in
                                
                                switch response.result {
                                case .success( _):
                                    let js = JSON(response.data as Any)
                                    prom.fulfill(js)
                                case .failure(let error):
                                    prom.reject(error)
                }
            }
        }
    }
}
