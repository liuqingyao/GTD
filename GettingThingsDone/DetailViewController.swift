//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    var sectionTitles = ["Task", "History", "Collaborators", "Peers"]
    
    @IBOutlet weak var historyTableView: UITableView!
    
    /**
     Add button function which inserts a new historyitem to the objects history Array
    */
    @IBAction func addButton(_ sender: Any) {
        print("Add Button pressed")
        let newItem = historyItem(creation: Date(), descr: "New Event", canEdit: true, id: NSUUID().uuidString)
        detailItem?.history.insert(newItem, at:0)
        historyTableView.reloadData()
        
        //Send new historyitem to peers
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: detailItem!)
        ptp?.send(data: encodedData, peers : detailItem!.collaborators)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Section switch statement, which returns the number of rows per section
        if detailItem != nil {
            switch section{
                case 0:
                    return 1
                case 1:
                    return (detailItem?.history.count)!
                case 2:
                    return (detailItem?.collaborators.count)!
                case 3:
                    if let p = ptp {
                        return p.peerList.count
                    } else { return 0}
                default:
                    fatalError("Out of section bound")
            }
        } else {
            return 0
        }
    }
    
    /**
     Cell for row at function which returns a cell depening on the section
     - section 0 : Task cell is returned
     - section 1 : History Item Cell is returned
     - section 2 : Collaborators Cell is returend
     - default: Fatal Error, due to not existing section
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
                cell.object = detailItem
                cell.ptp = ptp
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! historyTableViewCell
                cell.object = detailItem?.history[indexPath.row]
                cell.ptp = ptp
                cell.toDoItem = detailItem
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "collabCell", for: indexPath)
                if(detailItem!.collaborators[indexPath.row] != ptp?.peerId){
                    cell.textLabel!.text = detailItem!.collaborators[indexPath.row].displayName
                } else {
                    cell.textLabel!.text = "You"
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "collabCell", for: indexPath)
                cell.textLabel!.text = ptp?.peerList[indexPath.row].displayName
                return cell
            default:
                fatalError("Wrong Section Enumeration")
        }
    }
    
    //Row selection to select new collaborators
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 3){
            //Check if selected user is already a collaborator
            let index = detailItem?.collaborators.index(of: (ptp?.peerList[indexPath.row])!)
            if(index == nil){
                //Adding new collaborator
                let collab = ptp?.peerList[indexPath.row]
                detailItem?.addCollaborator(collab: collab!)
 
                tableView.reloadData()
    
                //Send ToDoItem to collaborator
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: detailItem!)
                ptp?.send(data: encodedData, peers : [collab!])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        if let dt = detailItem {
            //Notification Center
            let center = NotificationCenter.default
            //Observer when new peer joins
            center.addObserver(forName: NSNotification.Name(rawValue: "NewPeer"), object: nil, queue: nil){_ in
                print("New peer - reloading peer section. Count:")
                print(self.ptp!.peerList.count)
                self.historyTableView.reloadData()
            }
            
            //Observer method to act when peer is lost - updates peer section
            func catchNotification(notification:Notification){
                print("Lost peer - reloading peer section. Count:")
                print(self.ptp!.peerList.count)
                let userinfo = notification.userInfo!["peer"] as! MCPeerID
                //remove peer from todoitem
                detailItem?.removeCollaborator(collab: userinfo)
                self.historyTableView.reloadData()
            }
            
            //Observer to see when peer is lost
            center.addObserver(forName: NSNotification.Name(rawValue: "LostPeer"), object: nil, queue: nil, using: catchNotification)
            
            //Observer method to act when new history Item is added
            func checkHistoryItem(notification:Notification){
                let dataid = notification.userInfo!["id"] as! String
                //Check if new history Item is added to this to do item
                if(detailItem?.id == dataid){
                    print("New History Item received!")
                    self.historyTableView.reloadData()
                }
            }
            
            //Adding observer for new history items
            center.addObserver(forName: NSNotification.Name(rawValue: "newHistoryItem"), object: nil, queue: nil, using: checkHistoryItem)
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: ToDoItem? {
        didSet {
        }
    }
    
    var ptp : PeerToPeer?
}

