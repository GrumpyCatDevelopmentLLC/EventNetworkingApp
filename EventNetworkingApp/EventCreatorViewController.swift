//
//  EventCreatorViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 10/1/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import UIKit

protocol EventCreatorViewControllerDelegate {
    
    func eventCreatorViewController(_ controller: EventCreatorViewController, didCreateEvent allEvents: [Event])
    
}

class EventCreatorViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var dateAndTimePicker: UIDatePicker!
    @IBOutlet var createEvent: UIButton!
    
    var session: URLSession?
    var delegate: EventCreatorViewControllerDelegate?
    var events: [Event]?
    
    override func viewDidLoad() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.events = []
    }
    
    @IBAction func createEvent(_ sender: UIButton) {
        // move to api class
        
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.CreateEvent.rawValue)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let eventPayload = self.getDictionaryFromView()
            
            print(eventPayload)
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: eventPayload, options: []) as Data
            
            let task = self.session?.dataTask(with: request) { data, response, error in
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
                    print("\n\n\n\n\nstatusCode should be 200, but is \(httpStatus.statusCode)")
                }
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let responseEventContainerArray = jsonData["responseEventContainer"] as? [[String:AnyObject]]? ?? nil
                let error = jsonData["errorMessage"] as? String? ?? nil
                
                if responseEventContainerArray != nil && error == nil {
                    for eventData in responseEventContainerArray! {
                        let event = Event(data: eventData)
                        if self.events!.contains(event!) == false {
                            self.events?.append(event!)
                            print(event?.desc)
                        }
                    }
                } else {
                    print("\n\n\n\n\n\n\n\n\n\nnot working\n\n\n\n\n\n\n\n\n\n")
                }
                
                OperationQueue.main.addOperation() {
                    let mainBundle = Bundle.main
                    let storyBoard = UIStoryboard(name: "Main", bundle: mainBundle)
                    let nav = storyBoard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
                    let dest = nav.viewControllers.first as! EventsViewController
                    self.delegate = dest
                    self.delegate?.eventCreatorViewController(self, didCreateEvent: self.events!)
                }
            }
            task?.resume()
        }
        
        // move to api class
    }

    
    func getDictionaryFromView() -> [String: AnyObject] {
        let name = self.nameTextField.text!
        let location = self.locationTextField.text!
        let details = self.detailsTextView.text!
        let dateAndTime = stringFromDatePicker(self.dateAndTimePicker)
        
        let dict = [
            "name": name,
            "location": location,
            "dateAndTime": dateAndTime,
            "details": details
        ]
        
        return dict as [String: AnyObject]
    }
    
    func stringFromDatePicker(_ datePicker: UIDatePicker) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.full
        let stringDate = timeFormatter.string(from: datePicker.date)
        return stringDate
    }
    
}
