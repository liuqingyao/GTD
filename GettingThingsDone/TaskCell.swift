//
//  TaskCell.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class TaskCell : UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var taskField: UITextField!
    
    var object : ToDoItem? {
        didSet{
            taskField.text = object?.title
            taskField.becomeFirstResponder()
            taskField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let inText = textField.text {
            if let oj = object {
                oj.title = inText
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
