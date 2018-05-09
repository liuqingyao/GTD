//
//  historyTableViewCell.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class historyTableViewCell : UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    
    var object : historyItem? {
        didSet {
            configure(obj : object!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Should Return")
        if let inText = textField.text {
            if let oj = object {
                oj.description = inText
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changeAction(_ sender: Any) {
        object?.description = descriptionField.text!
    }
    
    func configure(obj : historyItem){
        descriptionField.text = obj.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy, H:mm"
        dateField.text = dateFormatter.string(from: obj.creation)
        
        if(!obj.editable){
            descriptionField.isUserInteractionEnabled = false
        } else {
            descriptionField.isUserInteractionEnabled = true
        }
        
        descriptionField.delegate = self
    }
}
