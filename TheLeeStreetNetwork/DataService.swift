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
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    //singleton (single instance) lets us access the database
    static let ds = DataService()
    
    //reference to the data base
    private var _REF_BASE = DB_BASE
    private var _REF_POST = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("username")
    
    //Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
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
    
    var REF_POST_IMAGES: FIRStorageReference {
        
        return _REF_POST_IMAGES
        
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USER.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
}
