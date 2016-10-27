//
//  EventCell.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkedInCountLabel: UILabel!
    @IBOutlet var dateAndTime: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var event: Event?
    
}
