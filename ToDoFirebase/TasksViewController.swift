//
//  TasksViewController.swift
//  ToDoFirebase
//
//  Created by Aleksandr Kalinin on 31.03.17.
//  Copyright © 2017 Aleksandr Kalinin. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func addTapped(_ sender: UIBarButtonItem) {
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
    
    cell.textLabel?.text = "This is cel number \(indexPath.row)"
    cell.textLabel?.textColor = .white
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
}

