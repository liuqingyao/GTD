//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation

/**
 To Do item Class to store information about a ToDoItem (title and historyArray)
 */
@objcMembers class ToDoItem : NSObject {
    
    dynamic var title : String
    dynamic var history : Array<historyItem>
    
    init(title : String){
        self.title = title
        self.history = []
        history.append(historyItem(creation: Date(), descr: "Added Item", canEdit: false))
    }
}

extension ToDoItem {
    
    /**
     Add Move Event function
     - parameter section: Name of the new Section where item is moved to
     - returns: New History Item with description about item move
     */
    public func addMoveEvent(section : String){
        history.insert(historyItem(creation: Date(), descr: "Moved Item to \(section)", canEdit : false), at: 0)
    }
    
    /**
    Change Title function which changes the objects title and adds an event that the title is changed
     - parameter nTitle: New title parameter
     - returns: History Objects is inserted to record item change
     */
    public func changeTitle(nTitle : String) {
        if(nTitle != self.title){
            history.insert(historyItem(creation: Date(), descr: "Changed Item name from \(self.title) to \(nTitle)", canEdit: false), at: 0)
            self.title = nTitle
        }
    }
    
}


