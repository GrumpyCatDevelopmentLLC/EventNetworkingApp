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
        if self.attendees == nil {
            self.attendees = []
        }
        
        OperationQueue.main.addOperation {
            self.listOfAttendees.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = self.event?.name
        self.locationLabel.text = self.event?.location
        self.dataAndTimeLabel.text = self.event?.dateAndTime
        self.detailsTextView.text = self.event?.details
        self.listOfAttendees.dataSource = self
        OperationQueue.main.addOperation {
            self.listOfAttendees.reloadData()
        }
        
//        let privateQueue = OperationQueue()
//        privateQueue.addOperation {
//            let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.GetAttendees.rawValue)
//            var request = URLRequest(url: url!)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            
//            let eventPayload = [
//                "id": "\(self.event?.id)",
//                "name": "\(self.event?.name)",
//                "location": "\(self.event?.location)",
//                "dateAndTime": "\(self.event?.dateAndTime)",
//                "details": "\(self.event?.details)"
//            ]
//            
//            request.httpBody = try! JSONSerialization.data(withJSONObject: eventPayload, options: [])
//            
//            let task = self.session?.dataTask(with: request) { data, response, error in
//                do {
//                    self.attendees = []
//                    let attendeesData = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]]
//                    
//                    for singleAttendee in attendeesData! {
//                        let attendee = User(data: singleAttendee)
//                        
//                        if self.user?.id == attendee?.id {
//                            OperationQueue.main.addOperation {
//                                self.listOfAttendees.reloadData()
//                            }
//                        } else {
//                            self.attendees?.append(attendee!)
//                        }
//                        
//                    }
//                    
//                } catch let error {
//                    print("error=\(error)")
//                }
//            }
//            task?.resume()
//        }
        
    }
    
    @IBAction func checkIntoEvent(_ sender: AnyObject) {
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.CheckIntoEvent.rawValue)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let checkInPayload: [String: Any] = [
                "event": [
                    "id":"\(self.event!.id!)",
                    "name":"\(self.event!.name!)",
                    "location":"\(self.event?.location!)",
                    "dateAndTime":"\(self.event?.dateAndTime!)",
                    "details":"\(self.event?.details!)"
                ]
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: checkInPayload, options: [])
            
            let task = self.session?.dataTask(with: request) { data, response, error in
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
                    print("\n\n\n\n\nstatusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let eventsJSONData = jsonData["myEvents"] as! [[String: AnyObject]]
                let error = jsonData["errorMessage"] as? String?
                print(eventsJSONData)
                
                if error == nil {
                    for eventAndUserData in eventsJSONData {
                        let userJSON = eventAndUserData["user"] as! [String: AnyObject]?
                        let myUser = User(data: userJSON!)
                        self.attendees?.append(myUser!)
                    }
                    
                    OperationQueue.main.addOperation {
                        self.listOfAttendees.reloadData()
                    }
                }
            }
            task?.resume()
            
        }
        print("\n\n\n\n\ncheck in\n\n\n\n\n")
    }
    
}

extension EventInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.attendees?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendeeCell") as! AttendeeCell
        let user = self.attendees?[indexPath.row]
        
        cell.displayNameLabel.text = user?.displayName
        
        return cell
    }
    
}
