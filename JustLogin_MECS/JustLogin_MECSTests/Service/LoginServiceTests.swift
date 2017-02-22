//
//  LoginServiceTests.swift
//  JustLogin_MECS
//
//  Created by Samrat on 19/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest
@testable import JustLogin_MECS

class LoginServiceTests: XCTestCase {
    
    /****************************/
    // MARK: - Properties
    /****************************/
    var loginService: LoginService!
    
    /****************************/
    // MARK: - Setup & Teardown
    /****************************/
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginService = LoginService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /****************************/
    // MARK: - Mock classes
    /****************************/
    class MockNetworkAdapter: NetworkAdapter {
        
        enum TestScenario: Int {
            case Success, Errors, Failure
        }
        
        let testScenario: TestScenario
        var payload: [String : Any] = [:]
        var headers: [String: String] = [:]
        var isPostCalled: Bool = false
        
        // Initializer
        init(forScenario testScenario: TestScenario) {
            self.testScenario = testScenario
        }
        
        func post(destination: String, payload: [String : Any], headers: [String : String], responseHandler: @escaping (NetworkAdapterResponse) -> Void) {
            
            self.payload = payload
            self.headers = headers
            isPostCalled = true
            
            switch testScenario {
            case TestScenario.Success:
                responseHandler(NetworkAdapterResponse.Success(response: [:],headers: headers))
            case TestScenario.Errors:
                responseHandler(NetworkAdapterResponse.Errors([:]))
            case TestScenario.Failure:
                responseHandler(NetworkAdapterResponse.Failure(""))
            }
        }
    }
    
    /****************************/
    // MARK: - Tests
    /****************************/
}
