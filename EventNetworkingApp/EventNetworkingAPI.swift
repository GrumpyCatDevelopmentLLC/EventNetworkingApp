//
//  EventNetworkingAPI.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/30/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import CoreData

internal enum EventNetworkingAPIMethods: String {
    case Login = "/login.json"
    case Logout = "/logout.json"
    case Profile = "/profile.json"
    case CreateUser = "/createUser.json"
    case CreateEvent = "/createEvent.json"
    case SaveEvent = "/saveEvent.json"
    case MyEvents = "/myEvents.json"
    case AllEvents = "/allEvents.json"
    case CheckIntoEvent = "/checkIn.josn"
}

internal enum EventResult: Error {
    case Success([Event])
    case Failure(Error)
}

struct EventNetworkingAPI {
    
    static let baseURL = "http://event-networking-app.herokuapp.com"
    //"http://hackathonallthethings.herokuapp.com"
    //"http://event-networking-app.herokuapp.com"
    //"http://192.168.86.120:8080"
    
    static func postDataToDatabase(method: EventNetworkingAPIMethods, data: [String: Any], customCompletion completion: () -> Void) {
    
        // generalize the https posts here
        
    }
    
    static func eventsFromJSONData(_ data: Data, error: Error?) -> EventResult {
        return EventResult.Failure(error!)
    }

    static func eventFromJSONDictionary(_ jsonDict: [String:AnyObject]) -> Event? {
        return nil
    }

}
