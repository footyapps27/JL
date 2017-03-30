//
//  AlamofireNetworkAdapter.swift
//  JustLogin_MECS
//
//  Created by Samrat on 30/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/***********************************/
// MARK: - AlamofireNetworkAdapter
/***********************************/
struct AlamofireNetworkAdapter: NetworkAdapter {
    
    func post(destination: String, payload: [String : Any], headers: [String : String]?, responseHandler: @escaping (NetworkAdapterResponse) -> Void) {
        
        // Check for internet
        if Utilities.connectedToNetwork() {
            log.debug("*****************************")
            log.debug("**** Web Service Request ****")
            log.debug("*****************************")
            log.debug("Request url -> \(destination)")
            log.debug("Request type -> HTTP POST")
            log.debug("Request headers -> \(headers)")
            log.debug("Request payload -> \(payload)")
            
            Alamofire.request(destination, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in responseHandler(response.networkAdapterResponse) }
        }
        else {
            // TODO: - Add this to the strings file.
            responseHandler(NetworkAdapterResponse.failure("No network connection"))
        }
    }
    
    func upload(destination: String, multipartFormData: ServiceMultipartFormData, payload: [String : String], headers: [String : String]?, responseHandler: @escaping (NetworkAdapterResponse) -> Void) {
        
        if Utilities.connectedToNetwork() {
            log.debug("*****************************")
            log.debug("**** Web Service Request ****")
            log.debug("*****************************")
            log.debug("Request url -> \(destination)")
            log.debug("Request type -> HTTP POST Multipart")
            log.debug("Request headers -> \(headers)")
            log.debug("Request payload -> \(payload)")
            
            Alamofire.upload(multipartFormData: { (formData) in
                
                formData.append(multipartFormData.fileURL, withName: multipartFormData.key)
                // Add the other values that are present in the request
                for (key, value) in payload {
                    formData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                }
                
            }, to: destination, headers: headers) { (encodingResult) in
                
                switch encodingResult {
                case .success(let uploadRequest, _, _):
                    uploadRequest.responseJSON(completionHandler: { (response) in
                        // In case of success, just pass that the request was a success. We are not passing any other information.
                        responseHandler(response.networkAdapterResponse)
                    })
                case .failure(let error):
                    log.debug("*****************************")
                    log.debug("**** Web Service Reponse ****")
                    log.debug("*****************************")
                    log.debug("Response url -> \(destination)")
                    log.debug("Multipart request FAILED")
                    log.debug("Error -> \(error.localizedDescription)")
                    // Incase of failure, just pass the localized description of the error. Ideally we should have passed the error that is received from server.
                    // TODO - Confirm if we need to pass the errors from the server.
                    responseHandler(NetworkAdapterResponse.failure(error.localizedDescription))
                }
            }
        } else {
            // TODO: - Add this to the strings file.
            responseHandler(NetworkAdapterResponse.failure("No network connection"))
        }
    }
}

/***********************************/
// MARK: - Alamofire.DataResponse
/***********************************/
/**
 * Extending the library response to be according to our custom response.
 */
extension Alamofire.DataResponse {
    
    var networkAdapterResponse: NetworkAdapterResponse {
        
        log.debug("*****************************")
        log.debug("**** Web Service Reponse ****")
        log.debug("*****************************")
        log.debug("Response url -> \(self.request?.url?.absoluteString)")
        
        let headers = self.response?.allHeaderFields as? [String: String]
        
        if let statusCode = self.response?.statusCode {
            log.debug("Response status code -> \(statusCode)")
        }
        
        log.debug("Response headers -> \(headers)")
        
        if let value = self.result.value {
            log.debug("Response payload -> \(value)")
        }
        
        if let message = self.result.error?.localizedDescription {
            log.error("Response failure -> \(message)")
            return NetworkAdapterResponse.failure(message)
        }
        
        // Check the success status code first.
        guard self.response?.statusCode == Constants.ResponseParameters.statusCode else {
            log.error("Invalid status code -> \(self.response?.statusCode)")
            return NetworkAdapterResponse.failure("Server returned status code != 200")
        }
        
        guard let json = self.result.value as? [String: Any] else {
            log.error("Invalid json received -> \(self.result.value)")
            return NetworkAdapterResponse.failure("Invalid JSON response")
        }
        
        if let errors = json[Constants.ResponseParameters.errors] as? [String: Any] {
            return NetworkAdapterResponse.errors(errors)
        }
        
        if let data = json[Constants.ResponseParameters.data] as? [String: Any] {
            return NetworkAdapterResponse.success(response: data, headers: headers)
        }
        log.error("Invalid JSON response for data key -> \(json[Constants.ResponseParameters.data])")
        return NetworkAdapterResponse.failure("Invalid JSON response for data key.")
    }
}
