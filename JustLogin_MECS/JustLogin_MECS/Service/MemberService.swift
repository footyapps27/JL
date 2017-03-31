//
//  MemberService.swift
//  JustLogin_MECS
//
//  Created by Samrat on 15/3/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IMemberService {
    
    /**
     * Method to retrieve approvers for the current user.
     */
    func getApproversForCurrentUser(_ completionHandler:( @escaping (Result<[Member]>) -> Void))
    
    /**
     Update the profile image of the current user.
     
     - Parameter payload: The payload items that will be added to the upload request.
     - Parameter imageURL: The URL of the image that needs to be uploaded.
     - Parameter completionHandler: Escaping completionHandler that will notify the success/failure of the request.
     
     */
    func updateProfileImage(payload: [String: String], imageURL: URL, completionHandler:( @escaping (Result<Void>) -> Void))
}

struct MemberService : IMemberService {
    
    var serviceAdapter: NetworkAdapter = NetworkAdapterFactory.getNetworkAdapter()
    
    /***********************************/
    // MARK: - IMemberService implementation
    /***********************************/
    
    func getApproversForCurrentUser(_ completionHandler:( @escaping (Result<[Member]>) -> Void)) {
        serviceAdapter.post(destination: Constants.URLs.Member.getApprovers, payload: [:], headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(let success, _ ):
                var allApprovers: [Member] = []
                if let jsonMembers = success[Constants.ResponseParameters.members] as? [Any] {
                    for approver in jsonMembers {
                        allApprovers.append(Member(withJSON: JSON(approver)))
                    }
                }
                completionHandler(Result.success(allApprovers))
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
    
    func updateProfileImage(payload: [String: String], imageURL: URL, completionHandler:( @escaping (Result<Void>) -> Void)) {
        let serviceMultipartData = getServiceMultipartFormData(forImageURL: imageURL)
        serviceAdapter.upload(destination: Constants.URLs.Member.uploadProfileImage, multipartFormData: serviceMultipartData, payload: payload, headers: Singleton.sharedInstance.accessTokenHeader) { (response) in
            switch(response) {
            case .success(_, _ ):
                completionHandler(Result.success())
            case .errors(let error):
                let error = ServiceError(JSON(error))
                completionHandler(Result.error(error))
            case .failure(let description):
                completionHandler(Result.failure(description))
            }
        }
    }
}
/***********************************/
// MARK: - Helpers
/***********************************/
extension MemberService {
    /**
     Wrap the image URL to ServiceMultipartFormData. This will hardcode the key.
     Same has been agreed with the server.
     
     - Parameter imageURL: The image URL that needs to be uploaded.
     
     */
    func getServiceMultipartFormData(forImageURL imageURL: URL) -> ServiceMultipartFormData {
        return ServiceMultipartFormData(fileURL: imageURL, key: Constants.RequestParameters.General.image)
    }
}
