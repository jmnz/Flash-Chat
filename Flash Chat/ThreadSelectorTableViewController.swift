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
    var selectedChat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        threadsTableView.delegate = self
        threadsTableView.dataSource = self
        threadsTableView.register(UINib(nibName: "CustomThreadCell", bundle: nil), forCellReuseIdentifier: "customThreadCell")
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
        return threadsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChat = indexPath.row
        print(selectedChat)
        self.performSegue(withIdentifier: "goToMessages", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customThreadCell", for: indexPath) as! CustomThreadCell
        cell.userAvatar.image = UIImage(named: "egg")
        cell.userName.text = threadsArray[indexPath.row].user
        
        return cell
    }
    
    func configuereTableView() {
        threadsTableView.rowHeight = 80
        threadsTableView.estimatedRowHeight = 120.0
    }
    
    func retrieveThreads() {
        let messageDB = Database.database().reference().child("Threads")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! [String:String]
            
            if snapshotValue["user1"] == self.currentUser {
                let newThread : Thread = Thread(Id: snapshotValue["messagesKey"]!, User: snapshotValue["user2"]!)
                self.threadsArray.append(newThread)
                
            } else if snapshotValue["user2"] == self.currentUser {
                let newThread = Thread(Id: snapshotValue["messagesKey"]!, User: snapshotValue["user1"]!)
                self.threadsArray.append(newThread)
            }
            
            self.configuereTableView()
            
            self.threadsTableView.reloadData()
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        chatVC.chatId = self.threadsArray[selectedChat].id
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
