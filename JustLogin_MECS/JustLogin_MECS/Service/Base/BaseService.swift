//
//  BaseService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 16/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

/***********************************/
// MARK: - NetworkAdapterResponse
/***********************************/
enum NetworkAdapterResponse {
    case success(response : [String: Any], headers : [String:String]?)
    case errors([String: Any])
    case failure(String)
}

/***********************************/
// MARK: - Result
/***********************************/
enum Result<T> {
    case success(T)
    case error(ServiceError)
    case failure(String)
}

/***********************************/
// MARK: - ServiceError
/***********************************/
struct ServiceError {
    let code: String
    let message: String
    
    init(_ json:JSON) {
        code = json[Constants.ResponseParameters.errorCode].stringValue
        message = json[Constants.ResponseParameters.errorMessage].stringValue
    }
}

/***********************************/
// MARK: - ServiceMultipartFormData
/***********************************/
/**
 Multipart form data, which is used for uploading images.
 */
struct ServiceMultipartFormData {
    var fileURL: URL
    var key: String
}

/***********************************/
// MARK: - NetworkAdapter
/***********************************/
/**
 * The adapter protocol that allows to call web services.
 */
protocol NetworkAdapter {
    
    /**
     Post an asynchronous HTTPPost request to the server.
     
     - Parameter destination: The URL of the end point to which the request needs to be posted.
     - Parameter payload: The payload of the request.
     - Parameter headers: The headers that need to be sent as part of the request.
     - Parameter responseHandler: Escaping NetworkAdapterResponse completion handler, which will be called after the request has received a response, or a timeout has taken place.

     */
    func post(destination: String, payload: [String: Any], headers: [String : String]?,responseHandler: @escaping (NetworkAdapterResponse) -> Void)
    
    /**
     Upload a file to the server. This uses multipart form data to achieve the same.
     
     - Parameter destination: The URL of the end point to which the request needs to be posted.
     - Parameter payload: The payload that will be attached as a part of the form data.
     - Parameter headers: The headers that need to be sent as part of the request.
     - Parameter responseHandler: Escaping NetworkAdapterResponse completion handler, which will be called after the request has received a response, or a timeout has taken place.
     
     */
    func upload(destination: String, multipartFormData: ServiceMultipartFormData, payload: [String: String], headers: [String : String]?,responseHandler: @escaping (NetworkAdapterResponse) -> Void)
}
