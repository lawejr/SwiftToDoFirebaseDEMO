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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    ref.observe(.value, with: { [weak self] snapshot in
      
      var _tasks: [Task] = []
      
      for item in snapshot.children {
        
        
        let task = Task(snapshot: item as! FIRDataSnapshot)
        _tasks.append(task)
      }
      
      self?.tasks = _tasks
      
      self?.tableView.reloadData()
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let currentUser = FIRAuth.auth()?.currentUser else { return }
    
    user = User(user: currentUser)
    ref = FIRDatabase.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    ref.removeAllObservers()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
    let task = tasks[indexPath.row]
    
    cell.textLabel?.text = task.title
    cell.textLabel?.textColor = .white
    toggleCompletion(cell, isCompleted: task.completed)

    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let task = tasks[indexPath.row]
      
      task.ref?.removeValue()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let task = tasks[indexPath.row]
    let isCompleted = !task.completed
    
    toggleCompletion(cell, isCompleted: isCompleted)
    task.ref?.updateChildValues(["completed": isCompleted])
    
  }
  
  func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
    cell.accessoryType = isCompleted ? .checkmark : .none
  }
  
}

