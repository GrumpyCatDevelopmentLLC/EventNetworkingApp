//
//  UserTests.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/30/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import XCTest
@testable import EventNetworkingApp

class UserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUserCreationWithDictionary() {
        
        let jsonData: [String : Any] = [
            "id": 0,
            "email": "admin@grumpycatdev.llc",
            "password": "admin",
            "displayName": "admin",
            "isOffensive": false
        ]
        
        let user = User(data: jsonData)!

        XCTAssert(user.id == 0)
        XCTAssert(user.email == "admin@grumpycatdev.llc")
        XCTAssert(user.password == "admin")
        XCTAssert(user.displayName == "admin")
        XCTAssert(user.isOffensive == false)
    }
  
}
