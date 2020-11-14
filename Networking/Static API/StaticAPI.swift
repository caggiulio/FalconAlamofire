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

public class StaticAPI: NSObject {
    
    internal static var requestManager: RestClient?
    
    public static func setup(baseUrl: String) {
        StaticAPI.requestManager = RestClient()
        requestManager?.setupBaseUrl(baseUrl: baseUrl)
    }
    
    public static func callAPI(url: String?, method: HTTPMethod, parameters: [String:AnyObject]? = nil, withQuery: Bool = false) -> Promise <JSON>? {
        if let _url = url {
            return StaticAPI.requestManager?.request(method, URIString: _url, parameters: parameters, withQuery: withQuery)
        }
        
        return nil
    }
}
