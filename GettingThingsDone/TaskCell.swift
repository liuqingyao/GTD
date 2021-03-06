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
    
    var observation : NSKeyValueObservation?
    
    /**
     Setting the objects properties
     */
    var object : ToDoItem? {
        didSet{
            taskField.text = object?.title
            taskField.becomeFirstResponder()
            taskField.delegate = self
            
            //Adding Key Value observer to update title
            observation = object!.observe(\.title){_, _ in
                self.taskField.text = self.object!.title
            }
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
                
                //Sending toDoItem Object to peers on update
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: oj)
                ptp?.send(data: encodedData, peers : oj.collaborators)
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    //PeerToPeer Object 
    var ptp : PeerToPeer?

}
