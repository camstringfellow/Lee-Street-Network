//
//  ViewController.swift
//  TheLeeStreetNetwork
//
//  Created by Cameron Stringfellow on 2/28/17.
//  Copyright © 2017 Stringfellow. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper


class ViewController: UIViewController {

    @IBOutlet var emailField: FancyField!
    //Dont forget to turn on privacy
    @IBOutlet var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("CAM: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Automatic login with Keychain
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("CAM: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //EMAIL AUTHENTICATION ----------------------------------------------
    
    @IBAction func emailSigninButton(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            //Sign in if user already exists
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("CAM: Email user successfully authenticated with Firebase")
                    
                    if let user = user {
                        
                        self.completeSignIn(id: user.uid)
                        
                    }
                    
                } else {
                    
                    //Create New User if one does not exist
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                      
                        if error != nil {
                            
                            //Something went wrong
                            print("CAM: Unable to Authenticate with Firebase using email")
                            print(error!)
                            
                        } else {
                            
                            print("CAM: Successfully authenticated with Firebase")
                            
                            if let user = user {
                                
                                self.completeSignIn(id: user.uid)
                                
                            }//if let user
                            
                        } //if error
                        
                    })//FIRAuth.auth()
                    
                }//if error
                
            }) //FIRAuth.auth()
            
        }//if let email
        
    }
    
    //-----------------------------------------------------------------
    

    //FACEBOOK AUTHENTICATION -----------------------------------------
    
    @IBAction func FBLogin(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("CAM: Unable to authenicate with Facebook - \(error)  ")
                
            } else if result?.isCancelled == true {
                
                print("CAM: User canceled Facebook login request")
                
            } else {
                
                print("CAM: Successfully authenicated with Facebook")
                
                //get credentail
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }//end if else
            
        } //facebookLogin.logIn
        
    }//FBLogin

    //------------------------------------------------------------------
    
    
    //FIREBASE AUTHENTICATION ------------------------------------------
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        //(user, error) <- completion handler of signing method
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("CAM: Unable to authenicate with Firebase - \(error)  ")
                
            } else {
                
                print("CAM: Successfully authenicated with Firebase")
                
                //moved this to func completeSignIn
                //KeychainWrapper.standard.set((user?.uid)!, forKey: KEY_UID)
                
                //unwrapping user (another way of doing "!" but this is the safe way
                if let user = user {
                    
                        //get the users UID
                        self.completeSignIn(id: user.uid)
                    
                }
                
            } //end else
        
        }) //FIRAuth.auth()
        
    }
    
    //----------------------------------------------------------------------

    //No access to uid because it is in another func. So add in a parameter so it can pass a string (the uid) and put that where the "user?.uid went and in the function with the uid, set it to a string and pass it through.
    func completeSignIn(id: String) {
        
        //save id to user
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("CAM: Data saved to keychain \(keychainResult)")
        
        //Send login directly to FeedViewController
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("CAM: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
        
    }//func completeSignIn
    
}

