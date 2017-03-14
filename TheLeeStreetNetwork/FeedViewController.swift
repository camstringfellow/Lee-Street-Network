//
//  FeedViewController.swift
//  TheLeeStreetNetwork
//
//  Created by Cameron Stringfellow on 3/2/17.
//  Copyright © 2017 Stringfellow. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func signOut(_ sender: Any) {
        
        //remove object from Keychain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        //print out what item was removed
        print("CAM: User keychain successfully removed")
        //Sign out from Firebase
        try! FIRAuth.auth()?.signOut()
        //Go back to homescreen
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostViewCell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
