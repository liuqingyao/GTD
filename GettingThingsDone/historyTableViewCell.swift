//
//  historyTableViewCell.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class historyTableViewCell : UITableViewCell {
    
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    
    public func configure(descr: String, inDate: Date) {
        descriptionField.text = descr
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy, H:mm"
        dateField.text = dateFormatter.string(from: inDate)

    }
}
