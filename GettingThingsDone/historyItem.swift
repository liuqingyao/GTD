//
//  historyItem.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 8/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation

class historyItem {
    
    var creation : Date
    var description : String
    
    init(creation : Date, description : String){
        self.creation = creation
        self.description = description
    }
    
}
