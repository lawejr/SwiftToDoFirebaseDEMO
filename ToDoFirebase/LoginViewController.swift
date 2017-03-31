//
//  ViewController.swift
//  ToDoFirebase
//
//  Created by Aleksandr Kalinin on 30.03.17.
//  Copyright © 2017 Aleksandr Kalinin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  let segueId = "tasksSegue"
  
  
  @IBOutlet weak var warnLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  @IBAction func loginTapped(_ sender: UIButton) {
    
    guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
      displayWarning(withText: "Error occured")
      return
    }
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
      if error != nil {
        self?.displayWarning(withText: "Error occured")
        return
      }
      
      if user != nil {
        self?.performSegue(withIdentifier: (self?.segueId)!, sender: nil)
        return
      }
      
      self?.displayWarning(withText: "No such user")
    })
    
  }
  
  @IBAction func registerTapped(_ sender: UIButton) {
    guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
      displayWarning(withText: "Info is incorrect")
      return
    }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
      
      if error == nil {
        guard user != nil else { print("User is not created"); return }
        // Переход на следующий viewController происходит по observer во viewDidLoad
      } else {
        self?.displayWarning(withText: "Email or password is incorrect")
      }
    })
  }
  
  // Очищаем экран перед показом
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    
//    emailTextField.text = ""
//    passwordTextField.text = ""
//    
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    warnLabel.alpha = 0
    
    FIRAuth.auth()?.addStateDidChangeListener({ [weak self] (auth, user) in
      if user != nil {
        self?.performSegue(withIdentifier: (self?.segueId)!, sender: nil)
      }
    })
  }
  
  
  func kbDidShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let kbFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
    // Увеличиваем высоту view на высоту клавиатуры
    //    (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
    
    (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    
    // Скролл до нужной точки
    (self.view as! UIScrollView).setContentOffset(CGPoint(x: 0.0, y: kbFrameSize.height), animated: true)
    
  }
  
  func kbDidHide() {
    // Возвращаем все назад
    
    //    (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    (self.view as! UIScrollView).setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
  }
  
  func displayWarning(withText text: String) {
    warnLabel.text = text
    UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
      self?.warnLabel.alpha = 1
    }) { [weak self] icomplete in
      self?.warnLabel.alpha = 0
    }
  }
  
}

