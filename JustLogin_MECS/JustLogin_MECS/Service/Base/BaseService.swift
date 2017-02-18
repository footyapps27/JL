//
//  BaseService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 16/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import Alamofire

/**
 * The response of the network adapter.
 */
public enum NetworkAdapterResponse {
    case Success([String: Any])
    case Errors([String: Any])
    case Failure(String)
}

/**
 * The adapter protocol that allows to call web services.
 */
protocol NetworkAdapter {
    
    func post(destination: String, payload: [String: Any], headers: [String : String],responseHandler: @escaping (NetworkAdapterResponse) -> Void)
}

/**
 * The AlamofireNetworkAdapter that implements the NetworkAdapter using Alamofire.
 */
struct AlamofireNetworkAdapter: NetworkAdapter {
    
    func post(destination: String, payload: [String : Any], headers: [String : String], responseHandler: @escaping (NetworkAdapterResponse) -> Void) {
        
        log.debug("*****************************")
        log.debug("**** Web Service Request ****")
        log.debug("*****************************")
        log.debug("request url -> \(destination)")
        log.debug("request type -> HTTP POST")
        log.debug("request headers -> \(headers)")
        log.debug("request payload -> \(payload)")
        
        Alamofire.request(destination, method: .post, parameters: payload, encoding: JSONEncoding.default)
            .responseJSON { response in responseHandler(response.networkAdapterResponse) }
    }
}

/**
 * Extending the library response to be according to our custom response.
 */
extension Alamofire.DataResponse {
    
    public var networkAdapterResponse: NetworkAdapterResponse {
        
        log.debug("*****************************")
        log.debug("**** Web Service Reponse ****")
        log.debug("*****************************")
        log.debug("response url -> \(self.request?.url?.absoluteString)")
        
        if let message = self.result.error?.localizedDescription {
            log.debug("response failure -> \(message)")
            return NetworkAdapterResponse.Failure(message)
        }
        
        log.debug("response status code -> \(self.response?.statusCode)")
        log.debug("response payload -> \(self.result.value)")
        
        // Check the success status code first.
        guard self.response?.statusCode == 200 else {
            return NetworkAdapterResponse.Failure("Server returned status code != 200")
        }
        
        guard let json = self.result.value as? [String: Any] else {
            return NetworkAdapterResponse.Failure("Invalid JSON response")
        }
        
        if let errors = json["errors"] as? [String: Any] {
            return NetworkAdapterResponse.Errors(errors)
        }
        
        return NetworkAdapterResponse.Success(json["data"] as! [String: Any])
    }
}
