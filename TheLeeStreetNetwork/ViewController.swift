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

    @IBOutlet var emailField: FancyField!
    //Dont forget to turn on privacy
    @IBOutlet var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //EMAIL AUTHENTICATION ----------------------------------------------
    
    @IBAction func emailSigninButton(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("CAM: Email user successfully authenticated with Firebase")
                    
                } else {
                    
                    FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                      
                        if error != nil {
                            
                            print("CAM: Unable to Authenticate with Firebase using email")
                            print(error)
                            
                        } else {
                            
                            print("CAM: Successfully authenticated with Firebase")
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
        
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
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("CAM: Unable to authenicate with Firebase - \(error)  ")
                
            } else {
                
                print("CAM: Successfully authenicated with Firebase")
                
                
            } //end else
        
        }) //FIRAuth.auth()
        
    }
    
    //----------------------------------------------------------------------

    
}

