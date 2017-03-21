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
    
    //array of posts
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //getting all data for each child
                for snap in snapshot {
                    //print each individual snapshot
                    print("SNAP: \(snap)")
                    
                    //Make sure it is the type it is supposed to be so no crashes
                    if let postDic = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDic)
                        //appending each post as they come in
                        self.posts.append(post)
                    }
                    
                }
                
            }
            //reload the data
             self.tableView.reloadData()
            //prints out value of posts in firebase
            //print(snapshot.value as Any)
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //number of cells to be the number of objects in array
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        //check
        print("CAM: \(post.caption)")
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostViewCell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

}
