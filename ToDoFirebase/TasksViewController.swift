//
//  TasksViewController.swift
//  ToDoFirebase
//
//  Created by Aleksandr Kalinin on 31.03.17.
//  Copyright © 2017 Aleksandr Kalinin. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var user: User!
  var ref: FIRDatabaseReference!
  var tasks: [Task] = []
  
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBAction func addTapped(_ sender: UIBarButtonItem) {
    
    let ac = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
      
      guard let textField = ac.textFields?.first, textField.text != "" else { return }
      
      let task = Task(title: textField.text!, userId: (self?.user.uid)!)
      let taskRef = self?.ref.child(task.title.lowercased())
      
      taskRef?.setValue(task.convertToDictionary())
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    
    ac.addTextField()
    ac.addAction(okAction)
    ac.addAction(cancelAction)
    
    present(ac, animated: true, completion: nil)
  }
  @IBAction func singOutTapped(_ sender: UIBarButtonItem) {
    do {
      try FIRAuth.auth()?.signOut()
    } catch {
      print("ERROR \(error.localizedDescription)")
    }
    
    // Попадаем на точку входа в приложение
    dismiss(animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let currentUser = FIRAuth.auth()?.currentUser else { return }
    
    user = User(user: currentUser)
    ref = FIRDatabase.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    
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

