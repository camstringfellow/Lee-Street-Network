//
//  DataService.swift
//  TheLeeStreetNetwork
//
//  Created by Cameron Stringfellow on 3/14/17.
//  Copyright © 2017 Stringfellow. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    //singleton (single instance)
    static let ds = DataService()
    
    //reference to the data base
    private var _REF_BASE = DB_BASE
    //reference to the posts in the database
    private var _REF_POST = DB_BASE.child("posts")
    
    private var _REF_USERS = DB_BASE.child("username")
    
    //secure so no one else can access
    
    var REF_BASE: FIRDatabaseReference {
        
        return _REF_BASE
        
    }
    
    var REF_POSTS: FIRDatabaseReference {
        
        return _REF_POST
        
    }
    
    var REF_USER: FIRDatabaseReference {
        
        return _REF_USERS
        
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USER.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
}
