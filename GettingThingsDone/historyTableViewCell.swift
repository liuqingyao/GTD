//
//  historyTableViewCell.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit
import MultipeerConnectivity

/**
 Custom historyTableView cell to display the date and description of a history Item
 */
class historyTableViewCell : UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    
    var toDoItem : ToDoItem?
    
    var observation : NSKeyValueObservation?
    
    var object : historyItem? {
        didSet {
            configure(obj : object!)
            //Key value observation to change description text when data changes
            observation = object?.observe(\.descr){_, _ in
                self.descriptionField.text = self.object?.descr
            }
        }
    }

    /**
    Return Function to save new input and to resign first responder
     - returns: Boolean
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let inText = textField.text {
            if let oj = object {
                oj.descr = inText
                
                //When history Text is changed updated todoitem is sent to collaborators 
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: toDoItem as! ToDoItem)
                ptp?.send(data: encodedData, peers : (toDoItem?.collaborators)!)
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Configuration function for custom cell, which sets the date and also sets wether
     - parameter obj : HistoryItem
     */
    func configure(obj : historyItem){
        descriptionField.text = obj.descr
        
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
    
    var ptp : PeerToPeer?
}
