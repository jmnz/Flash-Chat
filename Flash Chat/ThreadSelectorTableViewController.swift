//
//  ThreadSelectorTableViewController.swift
//  Flash Chat
//
//  Created by jesus jimenez on 4/1/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ThreadSelectorTableViewController: UITableViewController {
    
    
    @IBOutlet var threadsTableView: UITableView!
    
    var threadsArray = [Thread]()
    let currentUser = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()

        threadsTableView.delegate = self
        threadsTableView.dataSource = self
        configuereTableView()
        retrieveThreads()
        threadsTableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func configuereTableView() {
        threadsTableView.rowHeight = UITableView.automaticDimension
        threadsTableView.estimatedRowHeight = 120.0
    }
    
    func retrieveThreads() {
        let messageDB = Database.database().reference().child("Threads")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! [String:String]
            
            if snapshotValue["user1"] == self.currentUser {
                let newThread : Thread = Thread(Id: snapshot.key, User: snapshotValue["user2"]!)
                self.threadsArray.append(newThread)
                
            } else if snapshotValue["user2"] == self.currentUser {
                let newThread = Thread(Id: snapshot.key, User: snapshotValue["user1"]!)
                self.threadsArray.append(newThread)
            }
            
            //print(self.threadsArray)
            
            self.configuereTableView()
            
            self.threadsTableView.reloadData()
            
        }
        
        
    }


    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error, could not sing out")
        }
        
    }
}
