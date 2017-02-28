//
//  ViewController.swift
//  TheLeeStreetNetwork
//
//  Created by Cameron Stringfellow on 2/28/17.
//  Copyright © 2017 Stringfellow. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    @IBAction func FBLogin(_ sender: Any) {
    
        let facebookLogin = FBSDKLoginManager()
        
        //Facebook Authenication
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("Unable to authenicate with Facebook - \(error)  ")
                
            } else if result?.isCancelled == true {
                
                print("User canceled Facebook login request")
                
            } else {
                
                print("Successfully authenicated with Facebook")
                
                //get credentail
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }//end if else
            
        } //facebookLogin.logIn
        
    }//FBLogin
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        //Authenicate with Firebase
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("Unable to authenicate with Firebase - \(error)  ")
                
            } else {
                
                print("Successfully authenicated with Firebase")
                
                
            } //end else
        
        }) //FIRAuth.auth()
        
    }
    
}

