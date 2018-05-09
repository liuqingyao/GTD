//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation

class ToDoItem {
    
    var title : String
    var history : Array<historyItem>
    
    init(title : String){
        self.title = title
        self.history = []
        history.append(historyItem(creation: Date(), description: "Added Item", canEdit: false))
    }
}

extension ToDoItem {
    
    public func addMoveEvent(section : String){
        history.insert(historyItem(creation: Date(), description: "Moved Item to \(section)", canEdit : false), at: 0)
    }
    
    public func changeTitle(nTitle : String) {
        if(nTitle != self.title){
            history.insert(historyItem(creation: Date(), description: "Changed Item name from \(self.title) to \(nTitle)", canEdit: false), at: 0)
            self.title = nTitle
        }
    }
    
}


