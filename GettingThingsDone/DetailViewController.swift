//
//  DetailViewController.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 29/4/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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

