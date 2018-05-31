//
//  MasterViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

var sectionTitles = ["YET TO DO", "COMPLETED", "ICEBOX"]


class MasterViewController: UITableViewController, PeerToPeerDelegate {
    
    
    //Peer To Peer Manager
    func ptpmanager(_ manager: PeerToPeer, didReceive data: Data) {
        print("Manager called")
        //Received Item
        let item = (NSKeyedUnarchiver.unarchiveObject(with: data) as? ToDoItem)!
        
        var idx : IndexPath?
        
        //Checking if object already exists in objects array and saving indexpath to idx
        for s in 0..<objects.count{
            for r in 0..<objects[s].count{
                if(objects[s][r].id == item.id){
                    idx = IndexPath(row: r, section: s)
                }
            }
        }
        
        
        if var index = idx{
            //Check if Indexpath has changed
            if(index.section != item.index.section){
                print("Old index path: \(index)")
                print("New index path: \(item.index)")
                //remove old item
                objects[index.section].remove(at: index.row)
                objects[item.index.section].insert(item, at: 0)
                tableView.reloadData()
                
                //overwrite index
                index = IndexPath(row: 0, section: item.index.section)
            }
            
            //Updating object title
            objects[index.section][index.row].title = item.title
            //Updating collaborators list
            objects[index.section][index.row].collaborators = item.collaborators
            
            //History Item update
            for o in 0..<item.history.count {
                //If item already exist, update properties
                if(objects[index.section][index.row].history[o].id == item.history[o].id){
                    //Items are equal, only update descr
                    print("updating history (from to)")
                    print(objects[index.section][index.row].history[o].descr)
                    print(item.history[o].descr)
                    objects[index.section][index.row].history[o].descr = item.history[o].descr
                } else {
                    //If Item does not exist it will be added to array
                    print("Adding new history Item")
                    objects[index.section][index.row].history.insert(item.history[o], at: 0)
                    
                    //Notification Post to update Detail Views
                    let center = NotificationCenter.default
                    center.post(name: NSNotification.Name(rawValue: "newHistoryItem"), object: nil, userInfo : ["id" : objects[index.section][index.row].id])
                }
            }
        } else {
            //If indexpath does not exist new Item will be added to objects array depending on section
            print("New item received and added with id: \(item.id!)")
            objects[item.index.section].insert(item, at:0)
            tableView.reloadData()
        }
        
    }

    var ptp : PeerToPeer?
    var detailViewController: DetailViewController? = nil
    var objects = sectionTitles.map({_ in return [ToDoItem]()})
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        ptp = PeerToPeer()
        ptp?.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        //Setting index for item
        let index = IndexPath(row: 0, section: 0)
        //New ToDoItem
        let item = ToDoItem(title: "To Do Item \(objects[0].count+1)", id: NSUUID().uuidString, idx : index)
        //Add creator peer id to collaborators
        item.collaborators.append((ptp?.peerId)!)
        objects[0].insert(item, at: 0)
        
        //Insert new item into tableview
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.section][indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object as? ToDoItem
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.ptp = self.ptp
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects[section].count
    }

    var observations : NSKeyValueObservation?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.section][indexPath.row] as! ToDoItem
        cell.textLabel!.text = object.title
        
        //Key Value observation for title change
        observations = object.observe(\.title){_, _ in
            print("Change seen")
            tableView.reloadData()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Remove device id from collaborators
            let object = objects[indexPath.section][indexPath.row]
            print(object.collaborators)
            object.removeCollaborator(collab: (ptp?.peerId)!)
            
            //sending updated item to collaborators
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: object )
            print(object.collaborators)
            ptp?.send(data: encodedData, peers : object.collaborators)
            
            objects[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    objects[destinationIndexPath.section].insert(objects[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
        objects[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        //save change
        let obj = objects[destinationIndexPath.section][destinationIndexPath.row]
        if(destinationIndexPath.section != sourceIndexPath.section){
            obj.addMoveEvent(section : sectionTitles[destinationIndexPath.section])
            obj.index = destinationIndexPath
            //Sending changed indexpath to peers
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj )
            ptp?.send(data: encodedData, peers : obj.collaborators)
        }
        
    }


}

