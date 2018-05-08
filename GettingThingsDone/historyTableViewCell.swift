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
    
    func configure(obj : historyItem){
        descriptionField.text = obj.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy, H:mm"
        dateField.text = dateFormatter.string(from: obj.creation)
        
        descriptionField.becomeFirstResponder()
    }
}
