//
//  Event+CoreDataClass.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation

internal class Event: NSObject { //: NSManagedObject
    
    var id: Int?
    var name: String?
    var location: String?
    var dateAndTime: String?
    var details: String?
    var desc: String?
    
    required init?(data: [String: Any]) {
        guard let id = data["id"] as? Int? ?? nil,
            let name = data["name"] as! String?,
            let location = data["location"] as! String?,
            let dateAndTime = data["dateAndTime"] as! String?,
            let details = data["details"] as! String? else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.location = location
        self.dateAndTime = dateAndTime
        self.details = details
        self.desc = "ID: \(self.id)\nName: \(self.name)\nLocation: \(self.location)\nDate and Time: \(self.dateAndTime)\nDetails: \(self.details)"
    }
    
}
