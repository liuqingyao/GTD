//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sectionTitles = ["Task", "History", "Collaborators", "Peers"]
    
    @IBOutlet weak var historyTableView: UITableView!
    
    /**
     Add button function which inserts a new historyitem to the objects history Array
    */
    @IBAction func addButton(_ sender: Any) {
        print("Add Button pressed")
        let newItem = historyItem(creation: Date(), descr: "New Event", canEdit: true)
        detailItem?.history.insert(newItem, at:0)
        historyTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Section switch statement, which returns the number of rows per section
        switch section{
            case 0:
                return 1
            case 1:
                return (detailItem?.history.count)!
            case 2:
                return (detailItem?.collaborators.count)!
            case 3:
                return ptp!.peerList.count
            default:
                fatalError("Out of section bound")
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
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! historyTableViewCell
                let obj = detailItem!.history[indexPath.row] as historyItem
                cell.object = obj
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "collabCell", for: indexPath)
                cell.textLabel!.text = ptp?.peerList[indexPath.row].displayName
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "collabCell", for: indexPath)
                cell.textLabel!.text = ptp?.peerList[indexPath.row].displayName
                return cell
            default:
                fatalError("Wrong Section Enumeration")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 3){
            let index = detailItem?.collaborators.index(of: (ptp?.peerList[indexPath.row])!)
            if(index == nil){
                detailItem?.addCollaborator(collab: (ptp?.peerList[indexPath.row])!)
                tableView.reloadData()
                
                let messageDictionary: [String: String] = ["message": "Added you to collaborate!"]
                
                let dta = NSKeyedArchiver.archivedData(withRootObject: messageDictionary)
                ptp?.send(data: dta)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyTableView.delegate = self
        historyTableView.dataSource = self
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

