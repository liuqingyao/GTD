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
@objcMembers class historyItem : NSObject {
    
    dynamic var creation : Date
    dynamic var descr : String
    dynamic var editable : Bool
    
    init(creation : Date, descr : String, canEdit : Bool){
        self.creation = creation
        self.descr = descr
        self.editable = canEdit
    }
    
}
