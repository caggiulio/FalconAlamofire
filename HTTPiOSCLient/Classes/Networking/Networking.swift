//
//  Networking.swift
//  HTTPClient
//
//  Created by Nunzio Giulio Caggegi on 14/11/20.
//

import Foundation
import Alamofire

// enum used for convenience purposes (optional)
internal enum ServerURL: String {
    case base = "https://"
}

public struct FalconResponse {
    public var json: [String:Any]? = nil
    public var error: Error? = nil
    public var statusCode: Int?
    public var response: HTTPURLResponse? = nil
    public var data: Data?
    public var success: Bool
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
                          headers: HTTPHeaders = [:], localized: Bool = true, completion: @escaping (FalconResponse) -> ()) {
        
        if initialized == false {
            fatalError("YOU MUST CALL SETUP")
        }
        
        let header = defaultHeader
        var query: String = baseURL+URIString
        
        print("requestURL: \(query)")
        
        AF.request(query, method: method,
                          parameters: method == .get ? nil : parameters,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON { (response) in
                            
                            var finalJson: [String:Any]?
                            do {
                                if let data = response.data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    finalJson = json
                                }
                            } catch _ as NSError {

                            }
                            
                            switch response.result {
                            case .success( _):
                                let _response = FalconResponse(json: finalJson, error: response.error, statusCode: response.response?.statusCode, response: response.response, data: response.data, success: true)
                                completion(_response)
                            case .failure( _):
                                let _response = FalconResponse(json: finalJson, error: response.error, statusCode: response.response?.statusCode, response: response.response, data: response.data, success: false)
                                completion(_response)
            }
        }
        
    }
}
