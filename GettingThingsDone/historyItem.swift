//
//  historyItem.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation

/**
 History Item class to store information about the history Item creation, description and information if it can be changed 
 */
@objcMembers class historyItem : NSObject, NSCoding {
    
    dynamic var creation : Date!
    @objc dynamic var descr : String!
    dynamic var editable : Bool!
    @objc var id : String!
    
    //Encode function
    func encode(with aCoder: NSCoder) {
        if let creation = creation {
            aCoder.encode(creation, forKey: "creation")
        }
        if let descr = descr {
            aCoder.encode(descr, forKey: "descr")
        }
        aCoder.encode(editable, forKey: "editable")
        aCoder.encode(id, forKey : "id")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let creation = aDecoder.decodeObject(forKey: "creation") as! Date
        let descr = aDecoder.decodeObject(forKey: "descr") as! String
        let editable = aDecoder.decodeObject(forKey: "editable") as! Bool
        self.init(creation: creation, descr: descr, canEdit : editable, id : id)
    }
    
    
    init(creation : Date, descr : String, canEdit : Bool, id: String){
        self.creation = creation
        self.descr = descr
        self.editable = canEdit
        self.id = id
    }
    
}
