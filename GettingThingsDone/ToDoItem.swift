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
    var history : Array<Any>
    
    init(title : String){
        self.title = title
        self.history = []
    }
}
