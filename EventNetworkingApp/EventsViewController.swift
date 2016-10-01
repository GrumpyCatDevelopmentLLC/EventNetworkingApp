//
//  EventsViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import UIKit

enum TableViewState {
    case Events
    case Contacts
}

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var addEventButton: UIBarButtonItem!
    @IBOutlet var eventsButton: UIBarButtonItem!
    @IBOutlet var contactsButton: UIBarButtonItem!
    
    var state: TableViewState = .Events
    var eventStore: EventStore = EventStore()
    var user: User?
    var events = [Event]()
    var contacts = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        //      self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(user)
        print(events)
        print(contacts)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func changeStateAndReloadData(_ sender: UIBarButtonItem) {
        if self.state == .Events {
            self.state = .Contacts
        } else if self.state == .Contacts {
            self.state = .Events
        }
        
        self.tableView.reloadData()
    }
    
}

//extension EventsViewController: UITableViewDelegate {
//
//}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.state == .Events {
            return self.events.count
        } else if self.state == .Contacts {
            return self.contacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if self.state == .Events {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")
            
            
            
            
        } else if self.state == .Contacts {
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
            
            
            
        }
        
        return cell!
    }
    
}
