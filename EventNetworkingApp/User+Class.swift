//
//  User+CoreDataClass.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation

class User { // : NSManagedObject
    
    required public init?(data: [String: Any]) {
        guard let id = data["id"] as! Int64?,
            let email = data["id"] as! String?,
            let password = data["id"] as! String?,
            let displayName = data["id"] as! String?,
            let isOffensive = data["id"] as! Bool? else {
                return nil
        }
        
        self.id = id
        self.email = email
        self.password = password
        self.displayName = displayName
        self.isOffensive = isOffensive
    }
    
}
