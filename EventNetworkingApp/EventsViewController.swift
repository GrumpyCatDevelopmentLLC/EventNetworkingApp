//
//  EventsViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var addEventButton: UIBarButtonItem!
    @IBOutlet var navItem: UINavigationItem!
    
    var eventStore: EventStore = EventStore()
    var session: URLSession?
    var user: User?
    var events = [Event]()
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDisplayName = self.user!.displayName
        if userDisplayName.isEqual("sampson") || userDisplayName.isEqual("Admin") {
            self.navigationItem.rightBarButtonItem = self.addEventButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.AllEvents.rawValue)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = self.session?.dataTask(with: request) { data, response, error in
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
                    print("\n\n\n\n\nstatusCode should be 200, but is \(httpStatus.statusCode)")
                }
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let eventArray = jsonData["responseEventContainer"] as? [[String:AnyObject]]? ?? nil
                
                self.eventStore.events = []
                
                for eventData in eventArray! {
                    let event = Event(data: eventData)
                    self.eventStore.events.insert(event!, at: 0)
                }
                
                self.events = self.eventStore.events

                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            task?.resume()
            
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // request list of events from api
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(user)
        print(events)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        self.selectedEvent = event
        
        if self.selectedEvent != nil {
            let mainBundle = Bundle.main
            let storyBoard = UIStoryboard(name: "Main", bundle: mainBundle)
            let eventInfoView = storyBoard.instantiateViewController(withIdentifier: "EventInfoViewController") as! EventInfoViewController
            eventInfoView.event = self.selectedEvent
            eventInfoView.user = self.user
            show(eventInfoView, sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        let event = self.events[indexPath.row]
        cell.nameLabel.text = event.name
        cell.locationLabel.text = event.location
        cell.dateAndTime.text = event.dateAndTime
        cell.event = event
        
        return cell
    }
    
}

extension EventsViewController: EventCreatorViewControllerDelegate {
    
    func eventCreatorViewController(_ controller: EventCreatorViewController, didCreateEvent allEvents: [Event]) {
        self.events = allEvents
        controller.dismiss(animated: true, completion: nil)
    }
    
}
