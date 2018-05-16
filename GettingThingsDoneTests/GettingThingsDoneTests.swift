//
//  GettingThingsDoneTests.swift
//  GettingThingsDoneTests
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import XCTest
@testable import GettingThingsDone

class GettingThingsDoneTests: XCTestCase {
    
    func testToDoItem() {
        let item = ToDoItem(title : "Test")
        XCTAssertEqual(item.title, "Test" )
    }
    
    func testMoveHistoryItem(){
        let item = ToDoItem(title : "Testhistory")
        item.addMoveEvent(section: "testsection")
        XCTAssertEqual(item.history[0].descr, "Moved Item to testsection")
        XCTAssertFalse(item.history[0].editable)
    }
    
    func testRenameHistoryItem(){
        let item = ToDoItem(title : "First title")
        item.changeTitle(nTitle: "Second Title")
        XCTAssertEqual(item.history[0].descr, "Changed Item name from First title to Second Title")
        XCTAssertFalse(item.history[0].editable)
    }
    
    func testAddItem(){
        let item = ToDoItem(title : "Another Title")
        let date = Date()
        item.history.insert(historyItem(creation : date, descr : "Testdescription", canEdit: true), at : 0)
        XCTAssertTrue(item.history[0].editable)
        XCTAssertEqual(item.history[0].descr, "Testdescription")
        XCTAssertEqual(item.history[0].creation, date)
    }
    
    
}

