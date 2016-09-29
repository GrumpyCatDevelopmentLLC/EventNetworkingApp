//
//  User+CoreDataProperties.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: Int64
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var isOffensive: Bool
    @NSManaged public var attendingEvents: Event?
    @NSManaged public var organizedEvents: Event?

}
