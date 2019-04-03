//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {
    
    let usersDB = Database.database().reference().child("Users")
    let ThreadsDB = Database.database().reference().child("Threads")
    let MessagesDB = Database.database().reference().child("Messages")
    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveUser() {
        guard let UserMail = Auth.auth().currentUser?.email else {
            print("no mail")
            return
        }
        self.usersDB.childByAutoId().setValue(UserMail) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("saved to puclic database")
                self.usersDB.removeAllObservers()
                self.ThreadsDB.removeAllObservers()
                self.MessagesDB.removeAllObservers()
                SVProgressHUD.dismiss()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func createThreads(users:[String]) {
        var counter = 0
        guard let UserMail = Auth.auth().currentUser?.email else {
            print("no mail")
            return
        }
        for (user2) in users {
            if UserMail != user2 {
                let messagesThreadId = createMessageStorage()
                let thread : [String:String] = ["user1": UserMail, "user2":user2, "messagesKey":messagesThreadId]
                print(thread)
                self.ThreadsDB.childByAutoId().setValue(thread) {
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    } else {
                        counter += 1
                        if counter == users.count {
                        }
                    }
                }
            }
        }
    }
    
    
    func retrieveUsers() {
        var emailArr = [String]()
        self.usersDB.observe(.value) { (DataSnapshot) in
            if DataSnapshot.exists() {
                let emailDictionay = DataSnapshot.value as! [String:String]
                    for (_,email) in emailDictionay {
                        emailArr.append(email)
                        if emailArr.count == emailDictionay.count {
                            self.createThreads(users: emailArr)
                        }
                    }
                } else {
                self.saveUser()
            }
        }
    }
    
    func createMessageStorage() -> String {
        let newMessageStore = self.MessagesDB.childByAutoId()
        newMessageStore.setValue("empty") {
            (error, reference) in
            if error != nil {
                print(error!)
            }
        }
        return newMessageStore.key!
    }

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print()
            } else {
                self.saveUser()
                self.retrieveUsers()
            }
        }

        
        
    } 
    
    
}
