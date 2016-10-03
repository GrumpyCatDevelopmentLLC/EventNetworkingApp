//
//  EventStore.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/30/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation

class EventStore {
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack(modelName: "BookList")
    }()
    var events: [Event] = []
    
    func fetchEventsWithCompletion(completion: @escaping ([Event]) -> Void) {
        
    }
    
    func processEventsRequestWithData(_ data: Data?, error: Error?) -> EventResult {
        return EventResult.Failure(error!)
    }
    
    func fetchMainQueueEvents(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Event] {
        return []
    }
    
}
