//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var sectionTitles = ["History", "Collaborators"]
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var taskTitle: UITextField!
    
    @IBAction func taskTitle(_ sender: Any) {
        if let detail = detailItem {
            if let label = taskTitle {
                detail.title = label.text!
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        print("Add Button pressed")
        let newItem = historyItem(creation: Date(), description: "New Event happened")
        detailItem?.history.append(newItem)
        historyTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0:
                return (detailItem?.history.count)!
            case 1:
                return 0
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Loading Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! historyTableViewCell
        
        switch indexPath.section{
            case 0:
                let object = detailItem!.history[indexPath.row] as historyItem
                print(object.description)
                print(object.creation)
                cell.configure(descr: object.description, inDate: object.creation)
            default:
                fatalError("Wrong Section Enumeration")
        }
                
        return cell
    }
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = taskTitle {
                label.text = detail.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyTableView.delegate = self
        historyTableView.dataSource = self
        configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: ToDoItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

