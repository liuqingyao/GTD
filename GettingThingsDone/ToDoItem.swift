//
//  ToDoItem.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/**
 To Do item Class to store information about a ToDoItem (title and historyArray)
 */
@objcMembers class ToDoItem : NSObject, NSCoding {
    
    dynamic var id : String!
    dynamic var title : String!
    dynamic var history = [historyItem]()
    dynamic var collaborators = [MCPeerID]()
    
    init(title : String, id: String){
        self.id = id
        self.title = title
        self.history = []
        self.collaborators = []
        history.append(historyItem(creation: Date(), descr: "Added Item", canEdit: false))
    }
    
    required convenience init(coder decoder: NSCoder){
        let title = decoder.decodeObject(forKey: "title") as! String
        let id = decoder.decodeObject(forKey: "id") as! String
        self.init(title : title, id: id)
        self.history = decoder.decodeObject(forKey: "history") as! Array<historyItem>
        self.collaborators = decoder.decodeObject(forKey: "collaborators") as! Array<MCPeerID>
    }
    
    func encode(with coder: NSCoder){
        coder.encode(title, forKey: "title")
        coder.encode(history, forKey: "history")
        coder.encode(collaborators, forKey:"collaborators")
        coder.encode(id, forKey: "id")
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
    
    public func addCollaborator(collab: MCPeerID){
        history.insert(historyItem(creation: Date(), descr: "Added collaborator: \(collab.displayName)", canEdit: false), at: 0)
        collaborators.append(collab)
    }
    
}


