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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleImageView!
    
    //variables
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //initialize imagePicker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
        
        //reference
        let post = posts[indexPath.row]
        
        //check
        //print("CAM: \(post.caption)")
        
        //check to see if we can create a cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell") as? PostViewCell {
            
            //variable for image
            //var img: UIImage
            
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
                return cell
                
            } else {
                
                //configure cell (to file we specified)
                cell.configureCell(post: post)
                return cell
                
            }
            
        } else {
            
            //for saftey
            return PostViewCell()
        }
        
        //temporary cell
        //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostViewCell
        
    }

    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //check to make sure its a UIImage
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            
        } else {
            
            print("CAM: A valid image was not selected")
            
        }
        
        //once you select an image, get rid of it
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    
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
