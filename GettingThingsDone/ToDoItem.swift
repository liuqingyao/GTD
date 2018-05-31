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
@objc class ToDoItem : NSObject, NSCoding {
    
    @objc dynamic var id : String!
    @objc dynamic var title : String!
    @objc dynamic var history = [historyItem]()
    @objc dynamic var collaborators = [MCPeerID]()
    @objc dynamic var index : IndexPath
    
    init(title : String, id: String, idx : IndexPath){
        self.id = id
        self.title = title
        self.history = []
        self.collaborators = []
        self.index = idx
        history.append(historyItem(creation: Date(), descr: "Added Item", canEdit: false, id: NSUUID().uuidString))
    }
    
    required convenience init(coder decoder: NSCoder){
        let title = decoder.decodeObject(forKey: "title") as! String
        let id = decoder.decodeObject(forKey: "id") as! String
        let idx = decoder.decodeObject(forKey : "index") as! IndexPath
        self.init(title : title, id: id, idx : idx)
        self.history = decoder.decodeObject(forKey: "history") as! Array<historyItem>
        self.collaborators = decoder.decodeObject(forKey: "collaborators") as! Array<MCPeerID>
    }
    
    func encode(with coder: NSCoder){
        coder.encode(title, forKey: "title")
        coder.encode(history, forKey: "history")
        coder.encode(collaborators, forKey:"collaborators")
        coder.encode(id, forKey: "id")
        coder.encode(index, forKey: "index")
    }
}

extension ToDoItem {
    
    /**
     Add Move Event function
     - parameter section: Name of the new Section where item is moved to
     - returns: New History Item with description about item move
     */
    public func addMoveEvent(section : String){
        history.insert(historyItem(creation: Date(), descr: "Moved Item to \(section)", canEdit : false, id: NSUUID().uuidString), at: 0)
    }
    
    /**
    Change Title function which changes the objects title and adds an event that the title is changed
     - parameter nTitle: New title parameter
     - returns: History Objects is inserted to record item change
     */
    public func changeTitle(nTitle : String) {
        if(nTitle != self.title){
            history.insert(historyItem(creation: Date(), descr: "Changed Item name from \(self.title!) to \(nTitle)", canEdit: false, id: NSUUID().uuidString), at: 0)
            self.title = nTitle
        }
    }
    
    /**
     Add collaborator function which inserts a new MCPeerID and updates history
     - parameter collab: New MCPeerId
     - returns: History Objects is inserted to record item change
     */
    public func addCollaborator(collab: MCPeerID){
        history.insert(historyItem(creation: Date(), descr: "Added collaborator: \(collab.displayName)", canEdit: false, id: NSUUID().uuidString), at: 0)
        collaborators.append(collab)
    }
    
    /**
     Remove collaborator function which removes a new MCPeerID and updates history
     - parameter collab: MCPeerId
     - returns: History Objects is inserted to record item change
     */
    public func removeCollaborator(collab : MCPeerID){
        
        if let index = self.collaborators.index(of: collab){
            self.collaborators.remove(at: index)
            history.insert(historyItem(creation: Date(), descr: "Removed collaborator: \(collab.displayName)", canEdit: false, id: NSUUID().uuidString), at: 0)
        }
    }
    
}


