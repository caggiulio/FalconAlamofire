//
//  API.swift
//  HTTPClient
//
//  Created by Nunzio Giulio Caggegi on 14/11/20.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

public enum APIResult {
    case success(JSON)
    case error(Error)
}

public class Falcon: NSObject {
    
    internal static var requestManager: RestClient?
    
    public static func setup(baseUrl: String) {
        self.requestManager = RestClient()
        requestManager?.setupBaseUrl(baseUrl: baseUrl)
    }
    
    public static func request(url: String?, method: HTTPMethod, parameters: [String:AnyObject]? = nil, withQuery: Bool = false, completion: @escaping (APIResult) -> ()) {
        if let _url = url {
            self.requestManager?.request(method, URIString: _url, parameters: parameters, withQuery: withQuery).done({ (json) in
                completion(APIResult.success(json))
            }).catch({ (error) in
                completion(APIResult.error(error))
            })
        }        
    }
}
