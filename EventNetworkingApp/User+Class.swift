//
//  User+CoreDataClass.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation

internal class User { // : NSManagedObject
    
    var id: Int
    var email: String
    var password: String
    var displayName: String
    var isOffensive: Bool
    
    required init?(data: [String: Any]) {
        guard let id = data["id"]  as? Int? ?? nil,
            let email = data["email"] as! String?,
            let password = data["password"] as! String?,
            let displayName = data["displayName"] as! String?,
            let isOffensive = data["offensive"] as! Bool? else {
                return nil
        }
        
        self.id = id
        self.email = email
        self.password = password
        self.displayName = displayName
        self.isOffensive = isOffensive
    }
    
}
