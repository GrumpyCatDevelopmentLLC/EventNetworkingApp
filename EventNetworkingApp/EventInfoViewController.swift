//
//  EventInfoViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 10/2/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import UIKit

class EventInfoViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dataAndTimeLabel: UILabel!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var listOfAttendees: UITableView!
    @IBOutlet var checkInButton: UIButton!
    
    var session: URLSession!
    var user: User?
    var event: Event?
    var attendees: [User]?
    
    override func viewDidLoad() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = self.event?.name
        self.locationLabel.text = self.event?.location
        self.dataAndTimeLabel.text = self.event?.dateAndTime
        self.detailsTextView.text = self.event?.details
    }
    
    @IBAction func checkIntoEvent(_ sender: AnyObject) {
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.CheckIntoEvent.rawValue)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let checkInPayload: [String: Any] = [
                "user": [
                    "id":"\(self.user?.id)",
                    "email":"\(self.user?.email)",
                    "password":"\(self.user?.password)",
                    "displayName":"\(self.user?.displayName)",
                    "offensive":"\(self.user?.isOffensive)"
                ],
                "event": [
                    "id":"\(self.event!.id)",
                    "name":"\(self.event!.name)",
                    "location":"\(self.event?.location)",
                    "dateAndTime":"\(self.event?.dateAndTime)",
                    "details":"\(self.event?.details)"
                ]
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: checkInPayload, options: [])
            
            let task = self.session?.dataTask(with: request) { data, response, error in
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
                    print("\n\n\n\n\nstatusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let eventsJSONDataArray = jsonData["myEvents"] as! [[String: AnyObject]]
                let error = jsonData["errorMessage"] as! [String: AnyObject]?
                
                for eventJSONData in eventsJSONDataArray {
                    
                    let userJSON = eventJSONData["user"] as! [String: AnyObject]?
                    let user = User(data: userJSON!)
                    print("\n\n\n\n\n\(user)")
                }
                
                OperationQueue.main.addOperation {
                    self.listOfAttendees.reloadData()
                }
            }

            task?.resume()
        }
        
        print("\n\n\n\n\ncheck in\n\n\n\n\n")
    }
    
}
