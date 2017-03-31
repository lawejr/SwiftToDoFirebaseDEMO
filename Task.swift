//
//  Task.swift
//  ToDoFirebase
//
//  Created by Aleksandr Kalinin on 31.03.17.
//  Copyright © 2017 Aleksandr Kalinin. All rights reserved.
//

import Foundation
import Firebase

struct Task {
  let title: String
  let userId: String
  let ref: FIRDatabaseReference?
  var completed: Bool = false
  
  func convertToDictionary() -> Any {
    return ["title": title, "userId": userId, "completed": completed]
  }
  
  
  init(title: String, userId: String) {
    self.title = title
    self.userId = userId
    self.ref = nil
  }
  
  init(snapshot: FIRDataSnapshot) {
    let snapshotVal = snapshot.value as! [String: AnyObject]
    self.title = snapshotVal["title"] as! String
    self.userId = snapshotVal["userId"] as! String
    self.completed = snapshotVal["completed"] as! Bool
    self.ref = snapshot.ref
  }
}
