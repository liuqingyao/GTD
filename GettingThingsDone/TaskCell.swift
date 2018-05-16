//
//  TaskCell.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

/**
 Custom Cell for task item, which accepts a ToDoItem Object and sets the text
 */

class TaskCell : UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var taskField: UITextField!
    
    var object : ToDoItem? {
        didSet{
            taskField.text = object?.title
            taskField.becomeFirstResponder()
            taskField.delegate = self
        }
    }
    
    /**
     TextfieldShouldReturn Function which is called when return button pressed.
     The objects changeTitle function is called, which updates the objects title
     - returns: Boolean
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let inText = textField.text {
            if let oj = object {
                oj.changeTitle(nTitle: inText)
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
