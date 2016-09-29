//
//  Event+CoreDataProperties.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import CoreData

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var dateAndTime: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var organizer: User?
    @NSManaged public var attendingUsers: User?

}
