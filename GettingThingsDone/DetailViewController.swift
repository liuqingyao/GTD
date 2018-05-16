//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var sectionTitles = ["Task", "History", "Collaborators"]
    
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
            default:
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
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! historyTableViewCell
                let obj = detailItem!.history[indexPath.row] as historyItem
                cell.object = obj
                return cell
            default:
                fatalError("Wrong Section Enumeration")
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

}

