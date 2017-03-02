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

class FeedViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
