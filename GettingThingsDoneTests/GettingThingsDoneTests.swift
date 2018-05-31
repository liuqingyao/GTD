//
//  GettingThingsDoneTests.swift
//  GettingThingsDoneTests
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import XCTest
@testable import GettingThingsDone
import MultipeerConnectivity

class GettingThingsDoneTests: XCTestCase {
    
    func testToDoItem(){
        let item = ToDoItem(title: "Test", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        XCTAssertEqual(item.title, "Test" )
    }
    
    func testMoveHistoryItem(){
        let item = ToDoItem(title: "Test", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        item.addMoveEvent(section: "testsection")
        XCTAssertEqual(item.history[0].descr, "Moved Item to testsection")
        XCTAssertFalse(item.history[0].editable)
    }
    
    func testRenameHistoryItem(){
        let item = ToDoItem(title: "First", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        item.changeTitle(nTitle: "Second")
        XCTAssertEqual(item.history[0].descr, "Changed Item name from First to Second")
        XCTAssertFalse(item.history[0].editable)
    }
    
    func testAddItem(){
        let item = ToDoItem(title: "Test", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        let date = Date()
        item.history.insert(historyItem(creation: date, descr: "Testdescription", canEdit: true, id: NSUUID().uuidString), at: 0)
        XCTAssertTrue(item.history[0].editable)
        XCTAssertEqual(item.history[0].descr, "Testdescription")
        XCTAssertEqual(item.history[0].creation, date)
    }
    
    func testAddCollaborator(){
        let collaborator = MCPeerID(displayName: "Jannik")
        let item = ToDoItem(title: "Test", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        item.addCollaborator(collab: collaborator)
        XCTAssertEqual(item.collaborators[0], collaborator)
        XCTAssertEqual(item.history[0].descr!, "Added collaborator: Jannik")
    }
    
    func testRemoveCollaborator(){
        let collaborator = MCPeerID(displayName: "Jannik")
        let item = ToDoItem(title: "Test", id: NSUUID().uuidString, idx : IndexPath(row: 0, section: 0))
        item.addCollaborator(collab: collaborator)
        XCTAssertEqual(item.collaborators[0], collaborator)
        item.removeCollaborator(collab: collaborator)
        XCTAssert(item.collaborators.count == 0)
    }
    
    
}

