//
//  User.swift
//  ToDoFirebase
//
//  Created by Aleksandr Kalinin on 31.03.17.
//  Copyright © 2017 Aleksandr Kalinin. All rights reserved.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(user: FIRUser) {
    self.uid = user.uid
    self.email = user.email!
  }
  
}
